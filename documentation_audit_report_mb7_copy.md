# Auditoria da cópia da documentação do MBilling 7 para o MBilling 8

Data: 2026-07-13

## Escopo

Copiar a wiki de usuários mantida e a documentação de apoio à IA do MBilling 7 para o
MBilling 8 e depois acrescentar uma seção específica da versão, cobrindo Asterisk 20,
PJSIP e mensagens pelo WhatsApp Business.

## Inventário antes da cópia

- O MBilling 8 já continha as árvores da wiki em inglês e em português do Brasil.
- O MBilling 8 não continha a árvore `ia-docs`.
- O MBilling 7 tinha 406 arquivos de documentação versionados em `wiki/` e `ia-docs/`;
  o MBilling 8 tinha 338 arquivos versionados nesses caminhos.
- A cópia de trabalho do MBilling 8 já tinha alterações locais na documentação do
  WhatsApp nos dois índices da wiki e nas duas páginas de campanha geradas, além de
  guias independentes de campanha WhatsApp em inglês e em português do Brasil.
- O `wiki/generate.php` do MBilling 8 ainda continha configurações de execução
  específicas do MBilling 7 e não deveria ser executado nesta cópia.

## Conferência das fontes oficiais

- O `script/install.sh` instala explicitamente o Asterisk 20.
- A compilação do Asterisk usa o PJSIP/PJProject embutido, desativa o `chan_sip`, cria
  o `pjsip_magnus.conf` e o `pjsip_magnus_user.conf` e inclui os dois no `pjsip.conf`.
- A aplicação MBilling 8 usa identificadores PJSIP em filas, URAs, chamadas online,
  configuração de servidores e arquivos de contas gerados para o Asterisk.
- O guia atual de WhatsApp do MBilling 8 documenta a integração oficial com a WhatsApp
  Business Cloud API da Meta, modelos aprovados, execução de campanhas e respostas
  recebidas por webhook.

## Política de cópia e mesclagem

1. Copiar só os arquivos versionados no repositório do MBilling 7, evitando ambientes
   virtuais, saídas de compilação, caches e outros arquivos locais.
2. Preservar os quatro arquivos da wiki do MBilling 8 alterados localmente, em vez de
   sobrescrevê-los: os dois índices de idioma e as duas páginas de campanha.
3. Preservar os guias independentes de campanha WhatsApp já presentes no MBilling 8.
4. Acrescentar uma página permanente "Novidades do MBilling 8" para cada idioma da wiki
   e ligá-la a partir de uma seção dedicada do índice.
5. Acrescentar um documento de domínio equivalente para o apoio à IA e reconstruir os
   índices RAG locais depois da cópia.

## Plano de validação

- Conferir se cada entrada de `toctree` da wiki local aponta para um arquivo existente.
- Compilar as duas árvores de idioma do Sphinx sem executar o `wiki/generate.php`.
- Reconstruir e conferir os catálogos e os índices RAG do `ia-docs`.
- Confirmar que as alterações locais já existentes no MBilling 8 continuam presentes.
