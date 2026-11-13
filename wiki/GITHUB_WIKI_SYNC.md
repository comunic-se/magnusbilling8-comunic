# Sincronização com a wiki do GitHub

A documentação para usuários em `wiki/en` é a fonte oficial. A wiki do GitHub é um
destino de publicação em Markdown gerado a partir dela e não deve ser mantida à parte.

> Neste fork, o conteúdo de `wiki/en` foi traduzido para o português. O nome da pasta
> (`en`) foi mantido para não quebrar o exportador, os links e as referências do
> projeto oficial.

## Exportação local

```bash
python3 wiki/tools/export_github_wiki.py --output /tmp/magnusbilling8-wiki
```

O exportador:

- converte todas as páginas RST para Markdown;
- acrescenta um prefixo e achata os nomes das páginas para a wiki do GitHub;
- converte os links entre documentos do Sphinx e copia as imagens referenciadas;
- transforma os `toctree` do Sphinx e as referências de módulos gerados em links
  navegáveis;
- corrige os sublinhados de título do RST para o Markdown do GitHub;
- cria o `Home.md`, o `_Sidebar.md` e o `_Footer.md`;
- acrescenta links de volta para o índice da documentação e para o RST editável;
- confere se os links internos de páginas e imagens gerados apontam para algo que existe.

## Publicação

O GitHub guarda a wiki num repositório Git separado:

```bash
git clone https://github.com/magnussolution/magnusbilling.wiki.git
```

Esse repositório só existe depois que a primeira página da wiki é criada pela
interface do GitHub. O workflow `.github/workflows/sync-github-wiki.yml` exporta a
documentação, substitui o checkout da wiki gerada e só faz commit quando o resultado
muda. Ele roda em pushes no branch `source` (o branch do projeto oficial); neste fork,
o branch principal é `main`, então ele só roda se for disparado manualmente.

## Política de edição

Edite `wiki/en`. Quando uma página de módulo gerada vier das fontes de ajuda de campo
em `resources/help`, atualize a fonte da ajuda e gere de novo a página RST antes do
commit. As traduções da aplicação e a ajuda do painel são independentes da
documentação pública. Edições feitas direto na wiki do GitHub podem ser sobrescritas
pela próxima sincronização.

O exportador cuida só da apresentação. Ele não publica nem reescreve
`wiki/en/modules/*` nem `resources/help/help_en.js`, porque essa árvore gerada fornece a
ajuda contextual mostrada ao lado dos campos no MagnusBilling. A documentação pública
dos módulos é mantida à parte, em `wiki/en/module_overview.rst`.

Não publique o `ia-docs` na wiki de usuários. Ele é uma fonte de RAG voltada a máquinas,
com material interno de suporte e de navegação pelo código.
