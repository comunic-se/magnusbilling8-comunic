# Auditoria de qualidade da wiki do GitHub

Data da auditoria: 2026-07-14

## Escopo

- Documentação em `wiki/en` (originalmente em inglês; traduzida para o português neste fork).
- Exportação para Markdown e navegação da wiki do GitHub.
- Compatibilidade com a ajuda de campo contextual gerada a partir de `resources/help`.
- Pontos de entrada do repositório que levam o usuário à documentação.

## Constatações iniciais

- O exportador publicava 102 páginas RST em inglês, sendo 79 páginas geradas de
  referência de módulos e campos.
- A Home e a barra lateral geradas mostravam só uma pequena parte desse conteúdo.
- As diretivas `toctree` do Sphinx eram descartadas, deixando o índice público quase
  vazio.
- Os títulos RST com linha acima apareciam no Markdown como caracteres de enfeite
  literais.
- As páginas de campo geradas eram úteis dentro do MagnusBilling, mas muitas eram curtas
  demais para funcionar como documentação pública independente.
- O README do repositório não tinha link direto para a wiki do GitHub.

## Decisão de publicação

A wiki pública do GitHub do projeto oficial é só em inglês e é separada da ajuda de
campo contextual:

- `resources/help/help_en.js` e `wiki/en/modules/*` continuam sendo a fonte da ajuda
  mostrada ao lado dos campos no MagnusBilling.
- O exportador da wiki do GitHub exclui a árvore gerada `wiki/en/modules`.
- A orientação pública sobre os módulos é mantida em `wiki/en/module_overview.rst`.
- As melhorias de apresentação pública são feitas pelo exportador de Markdown, sem
  reescrever as fontes geradas da ajuda de campo.

## Critérios de aceitação

- A exportação da wiki do GitHub não contém páginas de referência de campo geradas
  (no projeto oficial, também não contém páginas em português).
- A Home e a barra lateral organizam a documentação pelas tarefas comuns do usuário.
- O índice completo contém links funcionando, gerados a partir dos `toctree` do Sphinx.
- Os enfeites de título do RST não aparecem no Markdown.
- Toda página pública tem links de volta para a Home, para o índice completo e para a
  fonte RST editável.
- A validação da exportação não aponta páginas internas nem imagens faltando.
- Rodar o exportador não altera nenhum arquivo em `wiki/en/modules`.
