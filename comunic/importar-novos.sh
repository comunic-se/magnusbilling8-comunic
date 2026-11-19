#!/bin/bash
#
# Comunic - traz do MB7 SOMENTE o que foi criado la depois da migracao para o MB8:
# clientes novos, contas SIP novas (de clientes novos ou ja existentes) e DIDs novos.
# NADA que ja existe no MB8 e alterado: saldo, plano, recargas [RC-AAAAMM], CDRs e
# configuracoes do MB8 ficam como estao. (O migrar-dados.sh SUBSTITUI tudo; com o MB8 em
# producao ele NAO deve mais ser usado.)
#
# Como e decidido o que e "novo":
#   cliente   login (username) que nao existe no MB8
#   conta SIP nome que nao existe no MB8 (o dono e achado pelo login)
#   DID       numero que nao existe no MB8 (com destinos e uso do DID)
# Planos, grupos de usuario e grupos de tronco sao ligados PELO NOME aos do MB8.
#
# Uso (como root, no MB8):
#   bash comunic/importar-novos.sh DUMP_MB7.sql.gz                 so mostra o que entraria
#   bash comunic/importar-novos.sh DUMP_MB7.sql.gz --aplicar       importa
#
# Opcoes:
#   --aplicar               importa de fato (sem ela nada e gravado no mbilling)
#   --reusar                nao carrega o dump de novo (usa o banco mbilling_mb7novos ja carregado)
#   --desde AAAA-MM-DD      so clientes criados no MB7 a partir desta data
#   --excluir U1,U2         nao traz estes logins (nem as contas SIP / DIDs deles)
#   --grupo "NOME=ID"       grupo de usuario do MB7 com nome diferente no MB8: NOME no MB7 =
#                           id do grupo no MB8 (ex.: --grupo "Cliente=3"); pode repetir
#   --zerar-saldo-novos     clientes novos entram com saldo 0 (padrao: saldo que tinham no MB7)
#   --sem-recargas          nao traz o historico de recargas dos clientes novos
#
# Dump pequeno (so as tabelas usadas), no MB7:
#   mysqldump --single-transaction --quick --hex-blob --default-character-set=utf8 mbilling \
#     pkg_user pkg_sip pkg_did pkg_did_destination pkg_did_use pkg_refill pkg_plan \
#     pkg_group_user pkg_trunk_group | gzip > /root/mb7-novos-$(date +%Y%m%d-%H%M).sql.gz
#
set -u
set -o pipefail
COM="$(cd "$(dirname "$0")" && pwd)"
. "$COM/lib/comum.sh"

ORIG=mbilling_mb7novos
DUMP=""; APLICAR=0; REUSAR=0; DESDE=""; EXCLUIR=""; ZERAR=0; RECARGAS=1; GRUPOS=()
while [ $# -gt 0 ]; do
    case "$1" in
        --aplicar) APLICAR=1 ;;
        --reusar) REUSAR=1 ;;
        --desde) DESDE=$(echo "${2:-}" | tr -cd '0-9-'); shift ;;
        --excluir) EXCLUIR="${2:-}"; shift ;;
        --grupo) GRUPOS+=("${2:-}"); shift ;;
        --zerar-saldo-novos) ZERAR=1 ;;
        --sem-recargas) RECARGAS=0 ;;
        -*) echo "Opcao desconhecida: $1"; exit 2 ;;
        *) DUMP="$1" ;;
    esac
    shift
done

[ "$(id -u)" = "0" ] || { echo "Rode como root (sudo -i)."; exit 1; }
if [ $REUSAR -eq 0 ]; then
    [ -n "$DUMP" ] && [ -f "$DUMP" ] || { echo "Uso: bash comunic/importar-novos.sh DUMP_MB7.sql(.gz) [--aplicar] (veja o cabecalho)"; exit 1; }
fi
[[ -z "$DESDE" || "$DESDE" =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}$ ]] || { echo "--desde precisa ser AAAA-MM-DD"; exit 1; }

q()  { mariadb -N -e "$1"; }
qo() { mariadb "$ORIG" -N -e "$1"; }
esc() { printf '%s' "$1" | sed "s/'/''/g"; }

TABELAS="pkg_user pkg_sip pkg_did pkg_did_destination pkg_did_use pkg_refill pkg_plan pkg_group_user pkg_trunk_group"

echo "Servidor: $(hostname) - IP $(hostname -I | awk '{print $1}')"
echo "Modo: $([ $APLICAR -eq 1 ] && echo 'APLICAR' || echo 'so conferir (nada sera gravado)')"

# ---------------------------------------------------------------- 1. carregar o dump
if [ $REUSAR -eq 0 ]; then
    echo "== Carregando o dump do MB7 no banco $ORIG ($(du -h "$DUMP" | awk '{print $1}'))"
    q "DROP DATABASE IF EXISTS $ORIG; CREATE DATABASE $ORIG CHARACTER SET utf8 COLLATE utf8_general_ci;" || exit 1
    if [[ "$DUMP" == *.gz ]]; then gunzip -c "$DUMP" | mariadb "$ORIG"; else mariadb "$ORIG" < "$DUMP"; fi \
        || { echo "ERRO ao carregar o dump."; exit 1; }
fi
for T in $TABELAS; do
    [ -n "$(q "SHOW TABLES FROM $ORIG LIKE '$T'")" ] || { echo "ERRO: a tabela $T nao esta no dump."; exit 1; }
done

# ---------------------------------------------------------------- 2. mapas (no banco $ORIG)
FILTRO_NOVO="d.id IS NULL"
[ -n "$DESDE" ] && FILTRO_NOVO="$FILTRO_NOVO AND o.creationdate >= '$DESDE'"
if [ -n "$EXCLUIR" ]; then
    LISTA=""; IFS=',' read -ra XS <<< "$EXCLUIR"
    for X in "${XS[@]}"; do X=$(echo "$X" | xargs); [ -n "$X" ] && LISTA="$LISTA${LISTA:+,}'$(esc "$X")'"; done
    [ -n "$LISTA" ] && FILTRO_NOVO="$FILTRO_NOVO AND o.username NOT IN ($LISTA)"
fi

qo "
DROP TABLE IF EXISTS _mu, _mp, _mg, _mtg, _ms, _md;
-- planos / grupos / grupos de tronco: pelo nome
CREATE TABLE _mp  AS SELECT o.id old_id, MIN(d.id) new_id, o.name FROM pkg_plan o LEFT JOIN mbilling.pkg_plan d ON d.name=o.name GROUP BY o.id, o.name;
CREATE TABLE _mg  AS SELECT o.id old_id, MIN(d.id) new_id, o.name FROM pkg_group_user o LEFT JOIN mbilling.pkg_group_user d ON d.name=o.name GROUP BY o.id, o.name;
CREATE TABLE _mtg AS SELECT o.id old_id, MIN(d.id) new_id, o.name FROM pkg_trunk_group o LEFT JOIN mbilling.pkg_trunk_group d ON d.name=o.name GROUP BY o.id, o.name;
-- usuarios: os que ja existem (pelo login) + os novos com id novo
CREATE TABLE _mu (old_id INT PRIMARY KEY, new_id INT, novo TINYINT, username VARCHAR(50));
INSERT INTO _mu SELECT o.id, MIN(d.id), 0, o.username FROM pkg_user o JOIN mbilling.pkg_user d ON d.username=o.username GROUP BY o.id, o.username;
INSERT INTO _mu SELECT o.id, (SELECT IFNULL(MAX(id),0) FROM mbilling.pkg_user) + ROW_NUMBER() OVER (ORDER BY o.id), 1, o.username
    FROM pkg_user o LEFT JOIN mbilling.pkg_user d ON d.username=o.username WHERE $FILTRO_NOVO;
-- contas SIP: as que ja existem (pelo nome) + as novas cujo dono esta no mapa
CREATE TABLE _ms (old_id INT PRIMARY KEY, new_id INT, novo TINYINT);
INSERT INTO _ms SELECT o.id, MIN(d.id), 0 FROM pkg_sip o JOIN mbilling.pkg_sip d ON d.name=o.name GROUP BY o.id;
INSERT INTO _ms SELECT o.id, (SELECT IFNULL(MAX(id),0) FROM mbilling.pkg_sip) + ROW_NUMBER() OVER (ORDER BY o.id), 1
    FROM pkg_sip o JOIN _mu u ON u.old_id=o.id_user LEFT JOIN mbilling.pkg_sip d ON d.name=o.name WHERE d.id IS NULL;
-- DIDs: os que ja existem (pelo numero) + os novos (sem dono ou com dono no mapa)
CREATE TABLE _md (old_id INT PRIMARY KEY, new_id INT, novo TINYINT);
INSERT INTO _md SELECT o.id, MIN(d.id), 0 FROM pkg_did o JOIN mbilling.pkg_did d ON d.did=o.did GROUP BY o.id;
INSERT INTO _md SELECT o.id, (SELECT IFNULL(MAX(id),0) FROM mbilling.pkg_did) + ROW_NUMBER() OVER (ORDER BY o.id), 1
    FROM pkg_did o LEFT JOIN mbilling.pkg_did d ON d.did=o.did
    WHERE d.id IS NULL AND (IFNULL(o.id_user,0)=0 OR o.id_user IN (SELECT old_id FROM _mu));
" || { echo "ERRO ao montar os mapas."; exit 1; }
for G in "${GRUPOS[@]}"; do
    GN="${G%=*}"; GI=$(echo "${G##*=}" | tr -cd '0-9')
    [ -n "$GN" ] && [ -n "$GI" ] && [ "$GN" != "$G" ] || { echo "ERRO: use --grupo \"NOME_NO_MB7=ID_NO_MB8\""; exit 1; }
    GD=$(q "SELECT name FROM mbilling.pkg_group_user WHERE id=$GI")
    [ -n "$GD" ] || { echo "ERRO: grupo id $GI nao existe no MB8"; exit 1; }
    [ -n "$(qo "SELECT 1 FROM _mg WHERE name='$(esc "$GN")'")" ] || { echo "ERRO: grupo '$GN' nao existe no MB7"; exit 1; }
    qo "UPDATE _mg SET new_id=$GI WHERE name='$(esc "$GN")'"
    echo "Grupo do MB7 '$GN' -> grupo do MB8 '$GD' (id $GI)"
done

NU=$(qo "SELECT COUNT(*) FROM _mu WHERE novo=1")
NS=$(qo "SELECT COUNT(*) FROM _ms WHERE novo=1")
ND=$(qo "SELECT COUNT(*) FROM _md WHERE novo=1")

# ---------------------------------------------------------------- 3. relatorio
BLOQ=0
bloqueio() { echo "   BLOQUEIO: $*"; BLOQ=1; }
tabela() { mariadb "$ORIG" -t -e "$1"; }

echo
echo "== Clientes novos: $NU"
[ "$NU" -gt 0 ] && tabela "SELECT o.username login, LEFT(CONCAT_WS(' ', NULLIF(o.company_name,''), NULLIF(CONCAT_WS(' ',o.firstname,o.lastname),' ')),40) nome,
       DATE(o.creationdate) criado, CONCAT(g.name,' -> ',IFNULL((SELECT name FROM mbilling.pkg_group_user x WHERE x.id=g.new_id),'?')) grupo_mb7_mb8, IFNULL(p.name,'-') plano, ROUND(o.credit,2) saldo_mb7, IF(o.active=1,'sim','nao') ativo
    FROM _mu u JOIN pkg_user o ON o.id=u.old_id LEFT JOIN _mg g ON g.old_id=o.id_group LEFT JOIN _mp p ON p.old_id=o.id_plan
    WHERE u.novo=1 ORDER BY o.creationdate, o.username"
ANTIGOS=$(qo "SELECT GROUP_CONCAT(o.username SEPARATOR ', ') FROM _mu u JOIN pkg_user o ON o.id=u.old_id
              WHERE u.novo=1 AND o.creationdate < '2026-10-20'")
[ -n "$ANTIGOS" ] && [ "$ANTIGOS" != "NULL" ] && {
    echo "   ATENCAO: criados ANTES de 20/10 (ja existiam na migracao; podem ter sido apagados no MB8 de proposito):"
    echo "   $ANTIGOS"
    echo "   Se nao devem voltar, use --excluir ou --desde 2026-10-20."; }

echo
echo "== Contas SIP novas: $NS"
[ "$NS" -gt 0 ] && tabela "SELECT o.name conta_sip, u.username dono, IF(u.novo=1,'novo','ja existe') cliente,
       IFNULL(tg.name, IF(IFNULL(o.id_trunk_group,0)>0, CONCAT('id ',o.id_trunk_group,' NAO EXISTE NO MB8'), '-')) grupo_tronco
    FROM _ms s JOIN pkg_sip o ON o.id=s.old_id JOIN _mu u ON u.old_id=o.id_user LEFT JOIN _mtg tg ON tg.old_id=o.id_trunk_group AND tg.new_id IS NOT NULL
    WHERE s.novo=1 ORDER BY u.username, o.name"

echo
echo "== DIDs novos: $ND"
[ "$ND" -gt 0 ] && tabela "SELECT o.did, IFNULL(u.username,'(sem dono)') dono,
       (SELECT COUNT(*) FROM pkg_did_destination x WHERE x.id_did=o.id) destinos
    FROM _md m JOIN pkg_did o ON o.id=m.old_id LEFT JOIN _mu u ON u.old_id=o.id_user
    WHERE m.novo=1 ORDER BY o.did"

echo
echo "== Conferencias"
X=$(qo "SELECT GROUP_CONCAT(DISTINCT CONCAT(o.username,' -> plano ',IFNULL(p.name,o.id_plan)) SEPARATOR '; ')
        FROM _mu u JOIN pkg_user o ON o.id=u.old_id LEFT JOIN _mp p ON p.old_id=o.id_plan
        WHERE u.novo=1 AND IFNULL(o.id_plan,0)>0 AND p.new_id IS NULL")
[ -n "$X" ] && [ "$X" != "NULL" ] && bloqueio "plano que nao existe no MB8 (crie com o MESMO nome e as tarifas): $X"
X=$(qo "SELECT GROUP_CONCAT(DISTINCT CONCAT(o.username,' -> grupo ',IFNULL(g.name,o.id_group)) SEPARATOR '; ')
        FROM _mu u JOIN pkg_user o ON o.id=u.old_id LEFT JOIN _mg g ON g.old_id=o.id_group
        WHERE u.novo=1 AND g.new_id IS NULL")
[ -n "$X" ] && [ "$X" != "NULL" ] && bloqueio "grupo de usuario que nao existe no MB8: $X"
X=$(qo "SELECT GROUP_CONCAT(o.username SEPARATOR ', ') FROM _mu u JOIN pkg_user o ON o.id=u.old_id
        JOIN mbilling.pkg_user d ON d.callingcard_pin=o.callingcard_pin WHERE u.novo=1")
[ -n "$X" ] && [ "$X" != "NULL" ] && bloqueio "PIN (callingcard_pin) ja usado por outro cliente no MB8: $X"
X=$(qo "SELECT GROUP_CONCAT(o.name SEPARATOR ', ') FROM _ms s JOIN pkg_sip o ON o.id=s.old_id
        JOIN mbilling.pkg_sip d ON d.techprefix=o.techprefix WHERE s.novo=1 AND o.techprefix IS NOT NULL")
[ -n "$X" ] && [ "$X" != "NULL" ] && bloqueio "techprefix ja usado no MB8 pelas contas: $X"

X=$(qo "SELECT GROUP_CONCAT(o.name SEPARATOR ', ') FROM pkg_sip o LEFT JOIN _ms s ON s.old_id=o.id WHERE s.old_id IS NULL")
[ -n "$X" ] && [ "$X" != "NULL" ] && echo "   Contas SIP NAO trazidas (dono excluido ou inexistente): $X"
X=$(qo "SELECT GROUP_CONCAT(o.did SEPARATOR ', ') FROM pkg_did o LEFT JOIN _md m ON m.old_id=o.id WHERE m.old_id IS NULL")
[ -n "$X" ] && [ "$X" != "NULL" ] && echo "   DIDs NAO trazidos (dono excluido): $X"
X=$(qo "SELECT GROUP_CONCAT(DISTINCT o.did SEPARATOR ', ') FROM _md m JOIN pkg_did o ON o.id=m.old_id
        JOIN pkg_did_destination x ON x.id_did=o.id WHERE m.novo=1 AND (IFNULL(x.id_ivr,0)>0 OR IFNULL(x.id_queue,0)>0)")
[ -n "$X" ] && [ "$X" != "NULL" ] && echo "   AVISO: DIDs novos com destino URA/fila (o destino entra sem a URA/fila; ajuste no painel): $X"
X=$(qo "SELECT GROUP_CONCAT(CONCAT(o.did,' (MB7: ',IFNULL(uo.username,'-'),' / MB8: ',IFNULL(ud.username,'-'),')') SEPARATOR '; ')
        FROM _md m JOIN pkg_did o ON o.id=m.old_id JOIN mbilling.pkg_did d ON d.id=m.new_id
        LEFT JOIN pkg_user uo ON uo.id=o.id_user LEFT JOIN mbilling.pkg_user ud ON ud.id=d.id_user
        WHERE m.novo=0 AND IFNULL(uo.username,'') <> IFNULL(ud.username,'')")
[ -n "$X" ] && [ "$X" != "NULL" ] && echo "   Info: DIDs que ja existem com dono diferente (NAO alterados): $X"
[ $BLOQ -eq 0 ] && echo "   nenhum bloqueio"

if [ $APLICAR -eq 0 ]; then
    echo
    echo "Nada foi gravado. Confira a lista e rode de novo com --aplicar (pode usar --reusar para nao recarregar o dump)."
    exit 0
fi
[ $BLOQ -eq 0 ] || { echo; echo "Ha bloqueios: nada foi gravado."; exit 1; }
[ $((NU + NS + ND)) -gt 0 ] || { echo; echo "Nada novo para importar."; exit 0; }

# ---------------------------------------------------------------- 4. aplicar
echo
read -r -p "Digite o nome deste servidor ($(hostname)) para importar: " OK
[ "$OK" = "$(hostname)" ] || { echo "Cancelado."; exit 1; }

BKP=/root/mb8-antes-novos-$(date +%Y%m%d-%H%M%S)
mkdir -p "$BKP"
echo "== Backup das tabelas afetadas em $BKP"
mariadb-dump --single-transaction mbilling pkg_user pkg_sip pkg_did pkg_did_destination pkg_did_use pkg_refill \
    | gzip > "$BKP/tabelas.sql.gz" || { echo "ERRO no backup. Nada foi feito."; exit 1; }
[ "$(gunzip -c "$BKP/tabelas.sql.gz" | grep -c 'CREATE TABLE')" -ge 6 ] || { echo "ERRO: backup incompleto. Nada foi feito."; exit 1; }

# colunas em comum (menos as tratadas), na ordem do MB8; EXPR[col] troca o valor
montar() {  # montar TABELA -> imprime "colunas|expressoes"
    local T="$1" C L="" E=""
    for C in $(q "SELECT d.COLUMN_NAME FROM information_schema.COLUMNS d JOIN information_schema.COLUMNS o
                  ON o.TABLE_SCHEMA='$ORIG' AND o.TABLE_NAME=d.TABLE_NAME AND o.COLUMN_NAME=d.COLUMN_NAME
                  WHERE d.TABLE_SCHEMA='mbilling' AND d.TABLE_NAME='$T' ORDER BY d.ORDINAL_POSITION"); do
        L="$L${L:+,}\`$C\`"
        E="$E${E:+,}${EXPR[$C]:-o.\`$C\`}"
    done
    echo "$L|$E"
}

SQL="$BKP/importacao.sql"
{
    echo "SET FOREIGN_KEY_CHECKS=0; START TRANSACTION;"

    declare -A EXPR=(
        [id]="m.new_id"
        [id_user]="IFNULL((SELECT x.new_id FROM $ORIG._mu x WHERE x.old_id=o.id_user),1)"
        [id_group]="(SELECT x.new_id FROM $ORIG._mg x WHERE x.old_id=o.id_group)"
        [id_group_agent]="IF(IFNULL(o.id_group_agent,0)>0,(SELECT x.new_id FROM $ORIG._mg x WHERE x.old_id=o.id_group_agent),o.id_group_agent)"
        [id_plan]="IF(IFNULL(o.id_plan,0)>0,(SELECT x.new_id FROM $ORIG._mp x WHERE x.old_id=o.id_plan),o.id_plan)"
        [id_offer]="NULL"
    )
    [ $ZERAR -eq 1 ] && EXPR[credit]="0"
    IFS='|' read -r L E <<< "$(montar pkg_user)"
    echo "INSERT INTO mbilling.pkg_user ($L) SELECT $E FROM $ORIG.pkg_user o JOIN $ORIG._mu m ON m.old_id=o.id AND m.novo=1 ORDER BY m.new_id;"

    declare -A EXPR=(
        [id]="m.new_id"
        [id_user]="(SELECT x.new_id FROM $ORIG._mu x WHERE x.old_id=o.id_user)"
        [id_trunk_group]="IFNULL((SELECT x.new_id FROM $ORIG._mtg x WHERE x.old_id=o.id_trunk_group),0)"
    )
    IFS='|' read -r L E <<< "$(montar pkg_sip)"
    echo "INSERT INTO mbilling.pkg_sip ($L) SELECT $E FROM $ORIG.pkg_sip o JOIN $ORIG._ms m ON m.old_id=o.id AND m.novo=1 ORDER BY m.new_id;"

    declare -A EXPR=(
        [id]="m.new_id"
        [id_user]="(SELECT x.new_id FROM $ORIG._mu x WHERE x.old_id=o.id_user)"
        [id_server]="NULL"
    )
    IFS='|' read -r L E <<< "$(montar pkg_did)"
    echo "INSERT INTO mbilling.pkg_did ($L) SELECT $E FROM $ORIG.pkg_did o JOIN $ORIG._md m ON m.old_id=o.id AND m.novo=1 ORDER BY m.new_id;"

    declare -A EXPR=(
        [id]="NULL"
        [id_did]="m.new_id"
        [id_user]="IFNULL((SELECT x.new_id FROM $ORIG._mu x WHERE x.old_id=o.id_user),1)"
        [id_sip]="(SELECT x.new_id FROM $ORIG._ms x WHERE x.old_id=o.id_sip)"
        [id_ivr]="NULL" [id_queue]="NULL"
    )
    IFS='|' read -r L E <<< "$(montar pkg_did_destination)"
    echo "INSERT INTO mbilling.pkg_did_destination ($L) SELECT $E FROM $ORIG.pkg_did_destination o JOIN $ORIG._md m ON m.old_id=o.id_did AND m.novo=1;"

    declare -A EXPR=(
        [id]="NULL"
        [id_did]="m.new_id"
        [id_user]="(SELECT x.new_id FROM $ORIG._mu x WHERE x.old_id=o.id_user)"
    )
    IFS='|' read -r L E <<< "$(montar pkg_did_use)"
    echo "INSERT INTO mbilling.pkg_did_use ($L) SELECT $E FROM $ORIG.pkg_did_use o JOIN $ORIG._md m ON m.old_id=o.id_did AND m.novo=1;"

    if [ $RECARGAS -eq 1 ]; then
        declare -A EXPR=( [id]="NULL" [id_user]="m.new_id" )
        IFS='|' read -r L E <<< "$(montar pkg_refill)"
        echo "INSERT INTO mbilling.pkg_refill ($L) SELECT $E FROM $ORIG.pkg_refill o JOIN $ORIG._mu m ON m.old_id=o.id_user AND m.novo=1;"
    fi

    echo "COMMIT; SET FOREIGN_KEY_CHECKS=1;"
} > "$SQL"

echo "== Importando (uma transacao so: se der erro, nada fica gravado)"
mariadb < "$SQL" || { echo "ERRO na importacao: nada foi gravado. SQL em $SQL"; exit 1; }

# conferencia
FU=$(q "SELECT COUNT(*) FROM mbilling.pkg_user d JOIN $ORIG._mu m ON m.new_id=d.id AND m.novo=1 AND m.username=d.username")
FS=$(q "SELECT COUNT(*) FROM mbilling.pkg_sip d JOIN $ORIG._ms m ON m.new_id=d.id AND m.novo=1")
FD=$(q "SELECT COUNT(*) FROM mbilling.pkg_did d JOIN $ORIG._md m ON m.new_id=d.id AND m.novo=1")
echo "   clientes $FU/$NU   contas SIP $FS/$NS   DIDs $FD/$ND"
q "SELECT d.username, d.credit, IFNULL(d.plan_type,'') FROM mbilling.pkg_user d JOIN $ORIG._mu m ON m.new_id=d.id AND m.novo=1" \
    > "$BKP/clientes-importados.tsv"

echo "== Gerando a configuracao PJSIP (contas novas) e recarregando"
bash "$COM/gerar-pjsip.sh" || echo "   FALHA no PJSIP: corrija e rode bash $COM/gerar-pjsip.sh"

# o banco com a copia do MB7 tem dados pessoais (LGPD): apaga
q "DROP DATABASE IF EXISTS $ORIG"

cat <<FIM

Concluido. Backup: $BKP/tabelas.sql.gz   Lista: $BKP/clientes-importados.tsv
Para desfazer (volta as 6 tabelas como estavam ANTES; o que mudou nelas depois se perde):
   gunzip -c $BKP/tabelas.sql.gz | mariadb mbilling && bash $COM/gerar-pjsip.sh

FALTA: os clientes novos entram SEM tipo de plano e SEM valor recorrente. Preencha no painel
(Clientes > Usuarios) ou com comunic/importar-planos.sh; a recarga do mes so pega quem tem plano.
FIM
