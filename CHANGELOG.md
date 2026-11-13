# Histórico de mudanças

Este arquivo registra as mudanças relevantes, visíveis ao usuário, da linha de versões
do MagnusBilling 8 e das customizações da Comunic. O projeto está em desenvolvimento
ativo; as tags de versão e as instruções de migração do banco continuam sendo a
referência oficial para a implantação.

## Comunic 1.3 (2026-11-13) — auditoria

- Backups seguros: `migrar-dados.sh`, `importar-banco.sh`, `atualizar-mb8.sh` e
  `importar-planos.sh` usam `set -o pipefail`; uma falha do `mariadb-dump` não fica mais
  escondida pelo `gzip`, e o `importar-banco.sh` só apaga o banco depois de conferir o backup.
- `atualizar-mb8.sh`: para se não conseguir extrair o pacote, em vez de seguir para a
  migração do banco.
- `aplicar.sh`: não regrava o crontab se a leitura falhar; os backups das execuções
  automáticas (vigia) usam o prefixo `mb8-custom-backup-auto-` e não apagam mais os
  backups das execuções manuais.
- Consumo por Plano: nome, usuário e tipo de plano codificados em HTML na grade (XSS).
- CSV do relatório e do backup: textos que começam com `=`, `+`, `-` ou `@` ganham um
  apóstrofo (injeção de fórmula no Excel).
- Endereço do repositório atualizado para `comunic-se/magnusbilling8-comunic`.
- Documentação traduzida para o português. Relatório em `comunic/docs/AUDITORIA-2026-11.md`.

## Comunic 1.2 (2026-10-02)

- `RecurringCredit agora`: faz o backup e a recarga na hora, em qualquer dia do mes (teste ou recarga manual),
  sem mudar o "Dia da recarga". Continua uma vez por mes por usuario e so para ativos com plano.

- Regras do 55 no dialplan (`_ZZXXXXXXXX` e `_0ZZXXXXXXXX` no `[billing]` do `extensions_magnus.conf`): o `saude.sh`
  confere se estao no arquivo e carregadas no Asterisk; o `aplicar.sh` (e o vigia, a cada 5 min) recoloca se uma
  atualizacao do MagnusBilling apagar, faz `dialplan reload` e manda alerta.

- `gerar-pjsip.sh` / `importar-banco.sh`: os arquivos `pjsip_magnus*.conf` ficam com o usuario do Apache como dono
  (antes ficavam root:asterisk 0640 e o painel dava "Nao foi possivel gravar o arquivo de configuracao do Asterisk").

- `custom/mb8-custom.js`: espera o login sem limite de tempo. Antes desistia depois de 2 minutos na tela de login,
  e as telas novas (campos do usuario e Consumo por Plano) nao apareciam ate recarregar a pagina.

- `PlanConsumptionSetup`: o menu Relatorios > Consumo por Plano passa a ser liberado para todos os grupos de
  administrador (Gestor, Suporte...), nao so o grupo 1 (na producao ninguem usa o grupo 1).

- Novo `comunic/gerar-pjsip.sh`: renomeia troncos com nome repetido (MB7 aceitava, PJSIP nao: "SIP name ... is used by
  trunks ..."), gera a configuracao PJSIP e recarrega o Asterisk. O `migrar-dados.sh` usa esse script e marca FALHA
  no relatorio se a configuracao nao for gerada.

- `migrar-dados.sh`: da ao usuario do MagnusBilling (`mbillingUser`) permissao no banco
  `mbilling_origem` antes do `UpdateMysql` (na Magalu dava "CDbConnection failed to open the DB connection").

- Novo `comunic/migrar-dados.sh`: migração **seletiva** de um dump do MB7/MB8 (clientes, SIP, DIDs,
  financeiro, tarifas, provedores Voxbeam/Algar/Datora/TIP/NVoip/Directcall com seus troncos,
  grupos e tarifas). Converte o dump numa base separada (`mbilling_origem`), faz backup antes,
  mantém os planos já preenchidos no MB8 e gera relatório (planos sem rota, SIP sem grupo, não migrado).
  Opções: `--somente-ativos`, `--zerar-saldo`, `--zerar-grupos`, `--sem-registro`, `--manter-troncos`,
  `--com-cdr`, `--sem-configuracoes`, `--provedores`, `--teste`.
- `docs/ROTEIRO-MAGALU.md` reescrito para o plano outubro (só comunic ativo) / 20 de novembro (virada).

## Comunic 1.1.2 (2026-10-01)

- `atualizar-mb8.sh --verificar`: ignora `script/`, `doc/`, `assets/` e `tmp/` do pacote (o instalador
  oficial apaga essas pastas), para reconhecer "Nenhuma versao nova" numa instalacao real.

## Comunic 1.1.1 (2026-10-01)

- `compat.sh`: falta de classe no `app.js` so e ERRO nos temas que podem ser escolhidos no painel
  (e no tema atual). Temas antigos como `red-classic` viram INFO (apareceu na instalacao da VM).

## Comunic 1.1 (2026-10-01)

Proteção contra as atualizações oficiais do MagnusBilling.

- **Nenhum arquivo oficial alterado**: `User.php`, `UserController.php`, `Configuration.php`
  e `permissions.php` voltaram ao original; as mudanças entram pelo mecanismo oficial de
  overrides (`protected/config/overrides.php`, `protected/models/overrides/UserOR.php`,
  `ConfigurationOR.php`). Cliente e revenda não veem nem alteram tipo de plano e valor
  recorrente. O `aplicar.sh` devolve o original onde encontrar a versão v11.
- `comunic/vigia.sh` (a cada 5 min): refaz `index.html`/traduções/arquivos se sumirem e avisa por e-mail.
- `comunic/atualizar-mb8.sh`: `--verificar` (segundas 07:10, só avisa), interativo e `--auto`;
  aplica somente o pacote conferido, bloqueia perto do dia da recarga e testa no fim.
- `comunic/compat.sh` (conferência do pacote novo) e `comunic/saude.sh` (conferência da instalação).
- Configuração `comunic_alert_email` e comando `ComunicAlert` para os alertas técnicos.
- Testado num MagnusBilling real (código oficial 8.0.0.15 + migração real para 8.0.0.16):
  cadastro por admin/cliente/revenda via HTTP, configurações, relatório, `dryrun`,
  vigia e 7 cenários de pacote (igual, compatível, dependência alterada, sem overrides,
  arquivo em conflito, frontend sem classe, banco em conflito).

## Comunic 1.0 (2026-10-01)

Customizações Comunic integradas ao código-fonte (antes distribuídas como pacote
`mb8-custom-v11.tar.gz`). Base oficial: MagnusBilling 8.0.0.16.

- Tipo de plano e valor recorrente no cadastro do usuário (`pkg_user.plan_type`, `recurring_value`).
- Relatórios > Consumo por Plano (Relatório de Recarga) com exportação CSV.
- Rotina mensal `RecurringCredit` (00:00 backup / 00:30 recarga, horário de Brasília) e
  e-mails ao financeiro; tabela `pkg_recurring_credit`.
- Configurações `finance_email`, `recurring_credit_groups`, `recurring_credit_day`.
- `comunic/instalar.sh` (servidor novo), `comunic/importar-banco.sh` (dump MB7/MB8),
  `comunic/aplicar.sh`, `comunic/atualizar-mb8.sh` (atualização manual; a automática
  das 01:30 fica desligada), testes em `comunic/testes/`.

## Não lançado (oficial)

### Documentação

- Reescritas a apresentação do repositório e as orientações de instalação, migração,
  desenvolvimento, arquitetura, suporte, segurança e contribuição.
- Acrescentados a missão do projeto, o escopo, as prioridades de engenharia e o roadmap.
- Corrigida a descrição da licença do repositório para LGPL-3.0.

## MagnusBilling 8

### Mudanças

- A base de telefonia suportada passou a ser o Asterisk 20.
- O `chan_sip` foi substituído pelo PJSIP nas instalações novas.
- Acrescentado um caminho de migração lado a lado do MagnusBilling 7 para o 8.

Para o comportamento detalhado da versão 8, veja
[Novidades do MB8](wiki/en/whats_new_mb8.rst). Para as mudanças específicas do banco,
revise o comando de atualização e as orientações de migração antes de implantar.
