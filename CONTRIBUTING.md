# Como contribuir com o MagnusBilling 8

Obrigado por ajudar a melhorar o MagnusBilling. Mudanças num software de tarifação e
telefonia podem afetar chamadas em curso, saldos de clientes e a segurança do servidor;
por isso, as contribuições devem ser focadas, testáveis e fáceis de revisar.

## Antes de começar

1. Procure issues e pull requests já existentes.
2. Abra uma issue para funcionalidade nova, mudança no esquema do banco, quebra de
   compatibilidade ou refatoração grande.
3. Não divulgue vulnerabilidades publicamente; siga o [SECURITY.md](SECURITY.md).
4. Leia o [PROJECT.md](PROJECT.md) e o [ARCHITECTURE.md](ARCHITECTURE.md) para conhecer
   o escopo e os limites do sistema.

Pequenas correções de erros e de documentação podem ser enviadas diretamente.

## Ambiente de desenvolvimento

Use um ambiente Linux descartável. A aplicação completa depende de PHP, MariaDB,
Apache, Asterisk 20 e PJSIP. Não faça experimentos com o instalador, migrações, banco,
firewall ou controle de chamadas num servidor de produção.

Para um ambiente completo, comece com um sistema operacional limpo suportado pelo
`script/install.sh`. Mantenha credenciais e dados reais de clientes fora de commits,
dados de teste, logs, capturas de tela e relatos de issue.

## Compilação do frontend

O cliente de administração usa Ext JS 6 e Sencha Cmd 6.2.

```bash
sencha app build development
sencha app build production
```

Ao preparar uma versão para implantar, os diretórios da aplicação exigidos pelo PHP
precisam ser incluídos junto com o frontend gerado. Evite mudanças não relacionadas nos
pacotes gerados.

## Testes e verificações

Rode primeiro a suíte mais específica e depois as verificações mais amplas que se
aplicam. Exemplos:

```bash
php -l protected/components/Example.php
phpunit protected/tests/unit/PjsipIpAuthenticationProbeTest.php
bash -n script/install.sh
```

Os testes disponíveis variam conforme o ambiente. O pull request deve dizer exatamente
o que foi executado e o que não pôde ser executado.

Mudanças na telefonia ou na instalação também precisam de um plano de validação num
sistema isolado. Mudanças em tarifação, saldos, pagamentos ou migrações do banco devem
cobrir novas tentativas, falhas parciais e casos-limite representativos.

## Padrões de código e documentação

- Siga o estilo do código ao redor e mantenha a mudança focada.
- Prefira componentes reutilizáveis a colocar regra de negócio nos controllers.
- Valide os dados em todos os limites externos, principalmente comandos de shell e do
  Asterisk.
- Nunca faça commit de senhas, tokens, chaves privadas, registros de produção ou dados
  de clientes.
- Acrescente ou atualize as traduções dos textos exibidos ao usuário.
- Escreva a documentação nova ou atualizada deste fork em português.
- Explique o impacto operacional, de configuração, de banco e de compatibilidade.
- Acrescente um teste de regressão ao corrigir um defeito.

## Mensagens de commit

Use títulos curtos e no imperativo e mantenha mudanças logicamente separadas em commits
separados. Exemplos:

```text
Corrige a validacao do endpoint PJSIP
Adiciona teste de regressao para novas tentativas de recarga
Documenta a instalacao no Debian 13
```

## Lista de conferência do pull request

- [ ] A mudança tem uma issue vinculada ou uma descrição clara do problema.
- [ ] A mudança não contém segredos nem arquivos gerados sem relação com ela.
- [ ] Os testes e a verificação manual estão documentados.
- [ ] Os riscos de tarifação, banco, API, segurança e telefonia foram considerados.
- [ ] Os textos visíveis ao usuário têm tradução, quando for o caso.
- [ ] A documentação e o `CHANGELOG.md` foram atualizados quando apropriado.
- [ ] Os passos de migração e de retorno estão incluídos nas mudanças operacionais.

Os mantenedores podem pedir validação adicional ou dividir uma mudança em pull requests
menores. Um pull request só é integrado depois da revisão exigida pelo projeto.

## Convivência

A participação é regida pelo [CODE_OF_CONDUCT.md](CODE_OF_CONDUCT.md). Dúvidas de
instalação e uso devem ir para os canais descritos em [SUPPORT.md](SUPPORT.md).
