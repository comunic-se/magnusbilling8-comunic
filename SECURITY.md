# Política de segurança

## Versões suportadas

O MagnusBilling 8 é a linha ativa de desenvolvimento e recebe correções de segurança.
O MagnusBilling 7 segue as datas e limitações da
[política de ciclo de vida](wiki/en/lifecycle.rst). Versões mais antigas não são
suportadas.

Os operadores devem manter a atualização mais recente da sua linha de versões
suportada. Uma versão suportada da aplicação não substitui as atualizações de segurança
do Linux, PHP, MariaDB, Apache, Asterisk e das demais dependências.

## Como comunicar uma vulnerabilidade

**Não** abra issue, discussão ou pull request público para uma suspeita de
vulnerabilidade.

Comunique em particular para `info@magnussolution.com` (código oficial do
MagnusBilling) ou para a equipe técnica da Comunic (customizações das pastas
`comunic/` e `custom/`), informando:

- uma descrição clara e o componente afetado;
- a versão ou o commit afetado;
- os pré-requisitos e os passos para reproduzir;
- o impacto e uma prova de conceito, se for seguro compartilhar;
- a mitigação sugerida, se você souber;
- seu contato preferido e como deseja ser creditado na divulgação.

Retire dados de clientes, credenciais, registros de chamadas e qualquer outro material
sensível desnecessário. Criptografe detalhes especialmente sensíveis antes de enviar e
combine a forma de transferência com os mantenedores.

## O que esperar

Os mantenedores vão validar o relato, avaliar as versões afetadas e coordenar a
correção e a divulgação de acordo com a gravidade e a capacidade do projeto. Dê tempo
para a análise antes de publicar detalhes. Se o relato não for uma vulnerabilidade,
você poderá ser direcionado a um canal de suporte ou a uma issue pública.

## Responsabilidades do operador

- trocar todas as credenciais padrão imediatamente;
- restringir o acesso ao SSH, ao painel de administração, ao AMI, ao banco e à gestão
  SIP a redes confiáveis;
- usar TLS onde a implantação permitir;
- aplicar as atualizações de segurança do sistema operacional e das dependências;
- manter backups verificados fora do servidor e testar a restauração;
- revisar com frequência contas, permissões, regras de firewall, Fail2ban e logs;
- nunca expor credenciais do banco ou da gestão do Asterisk em relatos públicos.

Há orientações de implantação voltadas à segurança também em `wiki/en/security/`.
