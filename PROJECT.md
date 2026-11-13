# Projeto

## Missão

O MagnusBilling 8 oferece uma plataforma aberta e auditável para operar e tarifar
serviços de telefonia IP. O objetivo é manter sob controle do operador todo o caminho,
do cadastro de clientes à tarifação das chamadas, ao roteamento e aos relatórios.

## Linha de versões atual

A versão 8 é a linha ativa de desenvolvimento. Sua base de plataforma é o Asterisk 20
com PJSIP. As instalações do MagnusBilling 7 precisam ir para um servidor novo e seguir
o processo documentado de migração do banco e da telefonia.

Os números de versão da aplicação e das migrações do banco não seguem o Versionamento
Semântico. As notas de versão e as instruções de migração são a referência oficial para
o impacto de uma atualização.

## Escopo do produto

### Núcleo

- clientes, revendas, autenticação e controle de acesso;
- tarifas, planos, provedores, troncos, rotas e tarifação de chamadas;
- endpoints SIP, DIDs, URAs, filas, callbacks e cartões telefônicos;
- CDRs, faturas, saldos, recargas, vouchers e relatórios;
- campanhas, call shop, tarefas agendadas e APIs;
- provisionamento Asterisk/PJSIP, controle por AMI e processamento de chamadas por AGI.

### Integrações

O repositório contém integrações com provedores de pagamento, serviços de mensagens,
fornecedores de DID, painéis de controle e APIs externas. Uma integração só é suportada
enquanto o contrato do provedor, as credenciais e as dependências necessárias continuam
compatíveis.

### Fora do escopo

- operar distribuições Linux não suportadas;
- atualizar o MagnusBilling 7 no mesmo servidor;
- substituir a estratégia de operadora, de rede ou de backup do banco;
- garantir compatibilidade com módulos de terceiros arbitrários;
- guardar segredos de implantação no código-fonte.

## Prioridades de engenharia

1. **Tarifação correta** — as mudanças de tarifa e de saldo devem ser determinísticas
   e rastreáveis.
2. **Operação segura da telefonia** — a configuração PJSIP e as ações sobre chamadas em
   curso devem falhar de forma previsível e mostrar diagnósticos úteis.
3. **Segurança** — autenticação, autorização, tratamento de entradas, segredos e os
   padrões do instalador exigem revisão conservadora.
4. **Confiança na migração** — quem opera a versão 7 precisa de passos de migração e
   validação explícitos e reversíveis.
5. **Clareza operacional** — as falhas devem ficar visíveis em logs, diagnósticos e
   documentação acionável.
6. **Manutenibilidade** — comportamentos novos devem ser isolados, testados, traduzidos
   e documentados.

## Roadmap

O roadmap indica uma direção, não um compromisso de entrega.

### Agora

- estabilizar o comportamento do Asterisk 20 e do PJSIP;
- melhorar o diagnóstico de falhas de chamada e de configuração;
- reforçar os caminhos de instalação, migração e atualização do banco;
- manter a documentação para usuários alinhada à versão 8;
- ampliar a cobertura de regressão nos limites entre tarifação e telefonia.

### Em seguida

- reduzir o acoplamento implícito entre controllers e serviços do sistema;
- padronizar o tratamento de erros das integrações e a gestão de segredos;
- melhorar as verificações automáticas de PHP, shell, traduções e documentação;
- facilitar a verificação das plataformas suportadas e da compatibilidade de
  atualizações.

### Depois

- modernizar aos poucos os limites do framework legado, sem atrapalhar quem opera em
  produção;
- melhorar o empacotamento e a reprodutibilidade dos ambientes de desenvolvimento;
- fortalecer a automação de versões e as orientações para desfazer uma atualização.

## Princípios de decisão

- A segurança da produção vem antes da conveniência da atualização.
- A compatibilidade com versões anteriores é mantida quando não preserva um
  comportamento legado inseguro.
- Mudanças no banco ou na tarifação exigem pensar explicitamente na migração e no
  retorno.
- Mudanças na telefonia exigem validação tanto da configuração quanto do funcionamento.
- A documentação pública para usuários é escrita junto com a mudança de comportamento
  que ela descreve. Neste fork, a documentação está em português.

## Critérios de sucesso

O projeto vai bem quando os operadores conseguem instalar ou migrar de forma
previsível, completar pelo PJSIP uma chamada tarifada corretamente, diagnosticar falhas
sem adivinhação, se recuperar de uma atualização usando backups documentados e
contribuir com uma mudança focada e com um caminho de verificação repetível.

## Como propor trabalho

Use as GitHub Issues para erros e propostas. Uma boa proposta descreve o problema do
operador, o fluxo afetado, o impacto na compatibilidade, as implicações de segurança,
as mudanças no banco e um plano de teste ou validação. Mudanças grandes devem ser
discutidas antes da implementação.

Veja o [CONTRIBUTING.md](CONTRIBUTING.md) para o fluxo de desenvolvimento e o
[ARCHITECTURE.md](ARCHITECTURE.md) para os limites do sistema.
