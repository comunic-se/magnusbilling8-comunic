# Auditoria do MagnusBilling 8 Comunic — novembro de 2026

Repositório: `comunic-se/magnusbilling8-comunic`, branch `main`, commit `8341e78` (13/11/2026).
Escopo: validação do projeto e dos scripts, riscos para produção em grande escala,
segurança e qualidade da construção. As correções feitas nesta auditoria estão no
branch `auditoria-traducao-pt-br`.

## Resumo

A customização está bem construída. Ela não altera nenhum arquivo oficial do
MagnusBilling: comparando com o commit oficial que serviu de base (`eae92c56`, de
23/09/2026), as únicas diferenças fora das pastas `comunic/`, `custom/` e dos arquivos
listados no `MANIFEST` são as duas traduções pt_BR, o `README.md`, o `CHANGELOG.md` e o
`.gitignore`. A recarga recorrente é idempotente (transação, `SELECT ... FOR UPDATE` e
chave única `id_user + month`) e atualiza o saldo de forma atômica, sem sobrescrever os
débitos de chamadas em andamento.

Os problemas mais sérios estavam nos scripts de operação: um backup que falhasse
podia passar despercebido antes de um `DROP DATABASE`/`DELETE`, e uma atualização
continuava mesmo sem conseguir extrair o pacote. Isso foi corrigido. O principal
ponto que continua aberto para grande escala é o espaço em disco consumido pelos
backups completos do banco feitos a cada atualização.

| Gravidade | Corrigidos nesta auditoria | Pendentes (recomendação) |
| --- | --- | --- |
| Alta | 2 | 1 |
| Média | 3 | 5 |
| Baixa | 3 | 6 |

## Validações executadas

- Sintaxe PHP (PHP 8.3) dos 10 arquivos PHP da customização: sem erros.
- Sintaxe JavaScript do `custom/mb8-custom.js`: sem erros.
- `bash -n` e `shellcheck` dos 16 scripts shell: sem erros; os avisos eram de variáveis
  definidas no `lib/comum.sh` e de padrões `case` sem aspas (corrigidos).
- `comunic/originais.sha256`: os 4 arquivos oficiais conferem, no repositório e na
  versão oficial mais recente.
- Arquivos oficiais de que a customização depende (`BaseController`, `User`,
  `Configuration`, `UserController`, `Model`): **iguais** na versão oficial mais recente
  (30/10/2026). A customização continua compatível.

## Corrigido nesta auditoria

### C1 — Alta: backup que falhava não interrompia operações destrutivas

`migrar-dados.sh`, `atualizar-mb8.sh` e `importar-planos.sh` faziam
`mariadb-dump ... | gzip > arquivo || erro`. Sem `pipefail`, o código de saída é o do
`gzip`, que dá certo mesmo quando o dump falha. O script seguia com um backup vazio para
o `DELETE`/migração. No `importar-banco.sh` o backup nem era conferido antes do
`DROP DATABASE`.

Correção: `set -o pipefail` nos quatro scripts e conferência do backup no
`importar-banco.sh`. A detecção de dump do `importar-banco.sh` (`LER | head | grep`) foi
ajustada para não acusar falso erro com o `pipefail` (testado).

### C2 — Alta: atualização seguia mesmo sem extrair o pacote

No `atualizar-mb8.sh`, se o `tar xzf` falhasse (disco cheio, pacote corrompido), o
script só registrava o erro e rodava a migração do banco com os arquivos pela metade.
Agora ele para, manda alerta e mostra como voltar.

### C3 — Média: crontab podia ser apagado

O `aplicar.sh` lia o crontab com `crontab -l 2>/dev/null` e regravava tudo com
`crontab -`. Se a leitura falhasse, o crontab era regravado só com as linhas da Comunic,
apagando as rotinas oficiais do MagnusBilling. Agora o crontab é lido uma vez e, se a
leitura falhar por outro motivo que não “sem crontab”, nada é alterado.

### C4 — Média: vigia em falha apagava os backups manuais

O vigia roda o `aplicar.sh` a cada 5 minutos enquanto algo estiver faltando, e cada
execução cria um backup e mantém só os 10 mais recentes. Em menos de uma hora, os
backups feitos nas execuções manuais eram apagados. Agora as execuções automáticas usam
o prefixo `/root/mb8-custom-backup-auto-` com rotação própria.

### C5 — Média: XSS na tela Consumo por Plano

As colunas Cliente, Usuário e Tipo de plano mostravam o texto do cadastro sem
codificar. Um nome com HTML/script seria executado no navegador do administrador. Agora
passam por `Ext.String.htmlEncode`.

### C6 — Baixa: injeção de fórmula nos CSV

Nomes, usuários e grupos que começam com `=`, `+`, `-` ou `@` viravam fórmula ao abrir
o `Relatorio_de_Recarga` ou o backup de saldo no Excel. Agora recebem um apóstrofo na
frente (`PlanConsumption::csvText`). Os valores numéricos não mudam.

### C7 — Baixa: erro do PlanConsumptionSetup não detectado no migrar-dados

O código de saída verificado era o do `sed`. Agora é o do PHP (`PIPESTATUS`).

### C8 — Baixa: endereço antigo do repositório

README, `instalar.sh` e o roteiro Magalu apontavam para `77uccena/mb8`. Atualizado para
`comunic-se/magnusbilling8-comunic`. **Nos servidores já instalados**, atualize o remoto:

```bash
cd /opt/mb8-comunic
git remote set-url origin git@github.com:comunic-se/magnusbilling8-comunic.git
```

A deploy key também precisa ser cadastrada no repositório novo.

Depois de juntar este branch, rode `bash comunic/aplicar.sh` em cada servidor: até lá o
`saude.sh` mostra os arquivos alterados como “diferentes do repositório”.

## Pendente — recomendações

### P1 — Alta (escala): disco cheio pelos backups de atualização

Cada atualização (`atualizar-mb8.sh`, inclusive no modo `--auto`) grava em `/root` o
dump **completo** do banco, incluindo `pkg_cdr`, e um `tar` do painel. Não há rotação
nem conferência de espaço livre. Com CDR grande, poucas atualizações enchem o disco, e
o MariaDB e o Asterisk param junto. Recomendações:

1. antes do dump, comparar o espaço livre (`df`) com o tamanho do banco
   (`information_schema.TABLES`) e não continuar se não couber;
2. manter só os 3 backups `/root/mb8-antes-atualizacao-*` mais recentes;
3. de preferência, gravar os backups num disco ou volume separado.

### P2 — Média: instalação não reproduzível

O `instalar.sh` e o `atualizar-mb8.sh` baixam o `MagnusBilling8-current.tar.gz`, que
muda sem aviso e não tem checksum publicado. Os codecs g729 também são baixados sem
conferência. Dois servidores instalados em semanas diferentes podem ter código
diferente. O `compat.sh` reduz o risco, mas recomenda-se guardar o pacote validado (com
sha256) e instalar novos servidores a partir dele (`atualizar-mb8.sh --pacote`).

### P3 — Média: código oficial do repositório atrás da versão oficial

A base do repositório é o commit oficial de 23/09/2026 (banco `8.0.0.15`). A versão
oficial já tem 4 commits depois disso (29–30/10/2026: correções de DID, PHP/instalador,
chamadas online e IAX) e o banco `8.0.0.17`. A produção não é afetada, porque a
instalação baixa o pacote atual, mas o repositório não mostra o que de fato roda. O
`comunic/README.md` também cita `8.0.0.16`. Recomenda-se sincronizar a pasta oficial com
a versão em produção a cada atualização aplicada.

### P4 — Média (escala): consulta sem índice na tela Consumo por Plano

`PlanConsumption::cycleRows` procura recargas antigas com
`pkg_refill WHERE description LIKE '%[RC-AAAAMM]%'`, que lê a tabela inteira toda vez
que a tela abre ou o CSV é exportado. Com centenas de milhares de recargas, fica lento.
Recomendação: acrescentar `AND date >= primeiro dia do mês do ciclo` (usa o índice de
data) ou consultar só a `pkg_recurring_credit` para os ciclos posteriores à criação da
foto.

### P5 — Média: mês perdido se o servidor ficar fora do ar

A rotina só considera o mês corrente e só age a partir do dia configurado. Se o servidor
ficar parado do dia 20 até o fim do mês, aquele ciclo não é recarregado e ninguém é
avisado. Também vale confirmar com o financeiro um comportamento atual: cliente
reativado (ou que recebe plano) depois do dia 20 é recarregado no dia em que aparece, e
nesse dia o financeiro recebe de novo os e-mails de backup e relatório.

### P6 — Média: o vigia reaplica tudo a cada 5 minutos enquanto a falha continuar

Cada tentativa faz `mariadb-dump` de quatro tabelas, regrava o crontab e roda o
`PlanConsumptionSetup`. Recomenda-se espaçar as tentativas depois da primeira falha
(por exemplo, no máximo uma tentativa por hora), como já é feito com os alertas.

### P7 — Baixa: crontab alterado por dois caminhos

O `aplicar.sh` usa `crontab -`, e o `PlanConsumptionSetup` grava direto em
`/var/spool/cron/crontabs/root`, sem passar pela validação do `crontab`. Recomenda-se
um arquivo próprio em `/etc/cron.d/mb8-comunic`.

### P8 — Baixa: cópia da produção esquecida após a migração

O `migrar-dados.sh` deixa o banco `mbilling_origem` (cópia completa da produção, com
dados pessoais) e dá `GRANT ALL` nele ao usuário do painel. O script só sugere apagar.
Recomenda-se apagar o banco e revogar a permissão ao final (LGPD).

### P9 — Baixa: arquivos de saldo sem retenção

Os CSV de backup e relatório em `protected/runtime/recurring_credit/` acumulam todo mês
sem limite. Estão protegidos do acesso web (`protected/.htaccess` e a configuração do
Apache), mas convém definir um prazo de retenção.

### P10 — Baixa: remetente do e-mail financeiro

`FinanceReportMailer` usa o usuário SMTP como remetente. Se o usuário do SMTP não for um
endereço de e-mail, o envio falha. Convém usar o “Admin Email” como remetente quando o
usuário não for um e-mail.

### P11 — Baixa: SQL manual diferente do comando

`comunic/sql/plan_consumption_manual.sql` libera o menu só para o grupo 1, enquanto o
`PlanConsumptionSetup` libera para todos os grupos de administrador.

### P12 — Baixa: sem verificação automática no GitHub

O único workflow sincroniza a wiki. Recomenda-se um workflow para `php -l`, `node --check`
e `shellcheck` dos arquivos da customização a cada push.

## Itens do MagnusBilling oficial (fora da customização)

- A instalação começa com `root`/`magnus`: troque no primeiro acesso e limite o painel e
  o SSH a redes confiáveis.
- A senha do SMTP fica em texto no banco (`pkg_smtp`): restrinja o acesso ao banco e aos
  dumps em `/root`.

## Avaliação da construção

Pontos fortes:

- uso do mecanismo oficial de overrides, sem alterar arquivos oficiais, o que permite
  atualizar o MagnusBilling sem perder a customização;
- `compat.sh` confere o pacote novo antes de aplicar, e a atualização é bloqueada perto do
  dia da recarga;
- a recarga é segura contra execução dupla e contra concorrência com chamadas em
  andamento, e grava um backup de saldo antes de qualquer alteração;
- os scripts destrutivos pedem o nome do servidor, fazem backup e mostram como voltar;
- os scripts de teste se recusam a rodar numa máquina com troncos ativos.

Pontos a melhorar: P1 a P6 acima, além de testes automáticos para as regras da
`PlanConsumption` (que hoje só existem como scripts de cenário para VM).

## Tradução da documentação

Traduzidos para o português: todos os `.md` da raiz, os modelos de issue e de pull
request do GitHub, `wiki/GITHUB_WIKI_SYNC.md`, as 110 páginas de `wiki/en` (o nome da
pasta foi mantido para não quebrar links e o exportador), os textos gerados pelo
exportador da wiki (com o teste ajustado) e o `ia-docs/README.md`. O índice
`ia-docs/indexes/rag_chunks.jsonl` foi gerado de novo com a wiki traduzida. A
validação com docutils não mostrou nenhum aviso novo nas páginas RST.

Ficaram em inglês, de propósito, os 40 documentos de `ia-docs/domains`, `playbooks` e
`sources`: são o corpus de recuperação da IA, e as perguntas de avaliação e as FAQs
geradas pelos scripts de `ia-docs/tools/` estão em inglês. Traduzir só os textos
deixaria o corpus desalinhado das avaliações. Se for traduzir, traduza junto as FAQs
de `build_rag_indexes.py` e gere os índices de novo.

## Comparação entre o GitHub e a pasta local

Comparada em 13/11/2026 a pasta `C:\Users\Pedro Lucena\Documents\Comunic\magnus billing 8 custom`
com o GitHub (`main`, commit `8341e78`):

- a pasta é um clone git no mesmo commit `8341e78` (branch `main`);
- os 14.377 arquivos versionados existem nos dois lados, com os mesmos tamanhos;
- 432 arquivos-chave (`comunic/`, `custom/`, código PHP da customização, AGI, traduções,
  scripts e documentação) têm conteúdo idêntico (mesmo hash git);
- a pasta tem 32 arquivos a mais, fora do git e ignorados pelo `.gitignore`: o
  `MagnusBilling 8 original.zip` (124 MB), testes JS de `classic/test/`, exemplos
  `bootstrap.js/css` do Ext JS e `protected/runtime/.htaccess`. Nenhum deles faz parte da
  customização;
- o remoto `origin` da pasta ainda aponta para `https://github.com/77uccena/mb8.git`.
  Troque com `git remote set-url origin https://github.com/comunic-se/magnusbilling8-comunic.git`.

A pasta `magnusbilling-source` não pôde ser montada e não foi comparada.
