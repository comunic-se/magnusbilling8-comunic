# Arquitetura

## Contexto do sistema

O MagnusBilling é uma aplicação web em PHP acoplada a um ambiente de telefonia. O
painel web e a API gerenciam a configuração comercial e técnica; comandos agendados
mantêm o estado operacional; o Asterisk executa as chamadas; o AGI aplica a lógica de
roteamento e tarifação; e o MariaDB é o registro oficial compartilhado.

## Componentes principais

### Cliente web

A aplicação Ext JS 6 fica principalmente em `app/`, com o código específico de cada
toolkit em `classic/` e `modern/`. Ela se comunica com os controllers Yii por HTTP. Os
pacotes compilados e o código do framework estão versionados neste repositório, então
uma mudança no frontend pode afetar tanto o código-fonte quanto os arquivos gerados.

### Backend web e API

O `index.php` inicia a aplicação Yii 1 usando `protected/config/main.php`. Os
controllers em `protected/controllers/` atendem as requisições do painel e da API. Os
models em `protected/models/` mapeiam o domínio para o MariaDB. A lógica operacional
reutilizável deve ficar em `protected/components/`, e não nos controllers.

A validação de CSRF e de cookies está ligada na configuração web principal. Endpoints
novos também precisam aplicar autenticação, autorização, validação de entrada e
tratamento seguro da saída, de acordo com quem os chama.

### Console e agendamento

O `cron.php` inicia a aplicação de console Yii configurada em
`protected/config/cron.php`. Os comandos em `protected/commands/` executam tarefas
periódicas, atualizações do banco, geração de relatórios e manutenção operacional. Os
comandos precisam ser seguros quando executados de novo e registrar contexto suficiente
para diagnosticar uma falha parcial.

### Ambiente de telefonia

As instalações novas usam Asterisk 20 e PJSIP. Os arquivos em `resources/asterisk/`
implementam o processamento de chamadas via AGI e a lógica de telefonia de apoio. Os
componentes do backend se comunicam com o Asterisk por AMI e geram ou recarregam a
configuração quando necessário.

Trate as chamadas do PHP para o shell, a CLI do Asterisk, o AMI e o AGI como limites de
confiança. Valide os identificadores e nunca coloque entrada não confiável dentro de um
comando.

### Persistência

O MariaDB guarda configurações, saldos, tarifas e registros de chamadas. O
`script/database.sql` contém a base da instalação; as atualizações são feitas pelo
comando de atualização do banco da aplicação.

As configurações do Yii leem as credenciais do banco em
`/etc/asterisk/res_config_mysql.conf`. Credenciais e configurações de produção devem
ficar fora do repositório.

## Fluxos de requisição e de chamada

### Requisição administrativa

```text
Navegador
  -> Apache/PHP
  -> index.php
  -> controller Yii
  -> model/componente
  -> MariaDB e, quando necessário, AMI do Asterisk
  -> resposta JSON/HTML
```

### Processamento de chamadas

```text
Aparelho SIP ou operadora
  -> Asterisk 20 / PJSIP
  -> dialplan
  -> AGI do MagnusBilling
  -> dados de roteamento e tarifa no MariaDB
  -> tronco/provedor escolhido
  -> atualização de CDR, saldo e relatórios
```

### Processamento agendado

```text
agendador do sistema
  -> cron.php
  -> comando de console Yii
  -> componente/model do domínio
  -> MariaDB, sistema de arquivos, serviço externo ou Asterisk
```

## Limites externos

O MagnusBilling pode se comunicar com gateways de pagamento, provedores de e-mail e de
mensagens, serviços de DID, WHMCS e outras APIs. Cada integração precisa definir:

- onde as credenciais são configuradas;
- tempos limite e comportamento de nova tentativa;
- verificação de assinatura ou de webhook;
- idempotência das operações financeiras;
- remoção de segredos e dados pessoais dos logs;
- uma resposta de falha clara para os operadores.

## Mudanças de alto risco

Mudanças nestas áreas exigem revisão adicional e verificação num ambiente parecido
com o de produção:

- busca de tarifa, duração da chamada, arredondamento, saldo, recarga e faturamento;
- esquema do banco ou comandos de atualização;
- autenticação, permissões, exposição da API e validação de webhooks;
- configuração do instalador, firewall, Fail2ban, Apache, MariaDB ou Asterisk;
- comportamento de endpoints PJSIP, troncos, rotas, dialplan, AMI ou AGI;
- retornos de pagamento e qualquer operação que possa ser repetida.

## Orientações de projeto

- Mantenha os controllers enxutos e leve o comportamento reutilizável para componentes.
- Mantenha as regras de persistência nos models ou em serviços de domínio explícitos.
- Torne as operações financeiras e de webhook idempotentes sempre que possível.
- Limite as operações de rede e do Asterisk com tempos limite.
- Devolva códigos de resultado estáveis, legíveis por máquina, e mensagens úteis para
  pessoas.
- Acrescente traduções para todos os textos novos exibidos ao usuário.
- Acrescente um teste de regressão focado para cada defeito corrigido.
- Documente as mudanças operacionais ou de compatibilidade no mesmo pull request.

## Premissas de implantação

O instalador suportado controla boa parte da configuração do sistema. Uma implantação
de produção abrange, portanto, o repositório e também o estado do Apache, PHP, MariaDB,
Asterisk, PJSIP, cron, firewall e Fail2ban. Testes apenas no repositório não comprovam
uma implantação completa; a validação de uma versão precisa incluir um servidor isolado
e um caminho real de chamada de entrada e de saída.
