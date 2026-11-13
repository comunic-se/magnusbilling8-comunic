# IA Docs do MagnusBilling (prontos para RAG)

Esta pasta é uma base de conhecimento voltada a máquinas, para assistentes de IA.
Ela fica separada de propósito da documentação para pessoas em wiki/.

> Neste fork, este README foi traduzido para o português. Os documentos de
> `domains/`, `playbooks/` e `sources/` e os índices gerados continuam em inglês,
> porque são o corpus de recuperação (RAG) e trazem perguntas de avaliação e FAQs em
> inglês geradas pelos scripts de `tools/`. Os trechos gerados a partir de `wiki/en`
> já estão em português.

## Objetivos

- Recuperação rápida para perguntas e respostas técnicas.
- IDs de documento estáveis para indexação e atualização de embeddings.
- Mapeamento explícito das fontes (código e transcrições de vídeo).
- Lógica das explicações em vídeo transformada em trechos no estilo FAQ para perguntas de suporte.
- Protocolo de resposta que exige evidências antes da resposta.

## Estrutura

- domains/: verdade técnica organizada por domínio (autenticação, tarifação, DID etc.).
- playbooks/: fluxos de resposta e de investigação.
- sources/: inventários de fontes e mapas de rastreabilidade.
- indexes/: manifestos legíveis por máquina para ingestão.

## Camadas de público

- user-support: responder com menus do painel, campos visíveis e conferências práticas.
- operator: incluir Asterisk, cron, logs, serviços e efeitos colaterais em produção.
- developer: rastrear pontos de entrada no código, models, controllers, AGI, comandos e tabelas.
- ai-agent: incluir IDs de documento e caminhos de recuperação para outro assistente.

## Wiki para pessoas x IA Docs

- `wiki/` é a documentação para usuários publicada com Sphinx/Read the Docs.
- `ia-docs/` é a documentação voltada a máquinas, usada por assistentes de IA.
- As descrições dos campos são compartilhadas entre a wiki pública e os ícones de
  ajuda do painel. A fonte delas é `resources/help/help_{LANG}.js`; os arquivos `.rst`
  gerados não devem ser o primeiro lugar a editar a ajuda de um campo.

## Dicas de ordenação na recuperação

O índice de trechos traz metadados de ordenação otimizados para recuperação em
perguntas de suporte:

- priority_tier: faq, core, transcript ou context.
- priority_score: peso normalizado de 0,4 a 1,0.
- rank_features: dicas extras de recuperação, como has_video_logic e has_resolution_steps.
- as intenções de consulta incluem intent_priority e doc_weights para recuperação por domínio.

Ordem de preferência esperada na recuperação:

1. Trechos de FAQ gerados a partir da lógica dos vídeos.
2. Trechos principais curados dos playbooks/domínios.
3. Trechos brutos de transcrição como contexto de apoio.

## Ordem recomendada de ingestão no RAG

1. indexes/rag_manifest.json
2. playbooks/qa_protocol.md
3. playbooks/question_routing.md
4. playbooks/user_question_to_module_map.md
5. playbooks/troubleshooting_flows.md
6. domains/*.md
7. sources/glossary.md
8. sources/module_catalog.md
9. sources/database_table_index.md
10. sources/user_wiki_sources.md
11. sources/video_transcripts.md

## Auditoria da documentação

A auditoria mais recente da documentação do repositório está em:

- indexes/documentation_audit_report.md

Use-a antes de ampliar a documentação. Ela lista páginas desatualizadas, páginas
faltando, inconsistências entre código e documentação e as lacunas de cobertura
restantes, encontradas comparando `wiki/`, `ia-docs/` e o código atual.

## Política de prioridade das fontes

1. O código atual do repositório é a referência oficial.
2. Os documentos curados do `ia-docs` dão a estrutura e o roteamento das respostas da IA.
3. As páginas da wiki de usuários dão o contexto e a terminologia para o usuário.
4. Vídeos/transcrições são orientação contextual e operacional.
5. Se alguma documentação contradisser o código, responda com o comportamento atual do código.

## Reconstruir os índices

Rode o gerador de índices para gerar de novo o manifesto, os trechos e as intenções:

python3 ia-docs/tools/build_rag_indexes.py

Gere de novo os catálogos derivados do código antes de reconstruir os índices quando
controllers, models, esquema, formulários ou ajuda de campos mudarem:

python3 ia-docs/tools/build_code_catalogs.py

Arquivos gerados:

- ia-docs/indexes/rag_manifest.json
- ia-docs/indexes/rag_chunks.jsonl
- ia-docs/indexes/query_intents.jsonl
- ia-docs/indexes/retrieval_eval.jsonl
- ia-docs/sources/module_catalog.md
- ia-docs/sources/database_table_index.md

O gerador de índices também cria trechos de apoio a partir da documentação de
usuários em `wiki/en`. Esses trechos têm prioridade menor que os trechos curados do
`ia-docs` e devem ser usados como contexto para o usuário, não como autoridade final
sobre o código.
