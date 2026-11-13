.. _module-overview:

Visão geral dos módulos do MagnusBilling
========================================

Esta página agrupa os principais módulos do MagnusBilling pela finalidade
operacional. Ela ajuda os administradores a achar a área certa do painel antes de
mudar uma configuração.

As descrições detalhadas dos campos aparecem dentro do próprio MagnusBilling. Abra
um formulário e use o botão de ajuda ao lado do campo para ver a descrição
contextual. Essas descrições são mantidas à parte desta wiki pública, para que o
painel continue sendo a referência oficial dos formulários atuais.

Gestão de clientes
------------------

* **Usuários** gerencia as contas dos clientes, planos, saldos, limites e o status
  da conta.
* **Usuários SIP** e **Usuários IAX** gerenciam os endpoints de telefonia e as
  credenciais.
* **CallerID** controla as identidades de chamador associadas aos usuários.
* **Chamadas online** mostra as chamadas ativas e as ações disponíveis em tempo real.
* **Números restritos** e **Callback** controlam as restrições de números e os
  serviços de callback.

Faturamento e pagamentos
------------------------

* **Recargas** registra as movimentações de crédito nas contas dos clientes.
* **Formas de pagamento** configura as opções de pagamento oferecidas pela plataforma.
* **Vouchers** cria códigos pré-pagos que os clientes podem resgatar.
* **Recargas de provedores** registra pagamentos e movimentações de crédito com os
  provedores.
* Os módulos de **Envio de crédito** gerenciam os produtos e as tarifas de
  transferência de crédito suportados.

Tarifas, planos e ofertas
-------------------------

* **Planos** agrupa as tarifas e os serviços atribuídos aos clientes.
* **Tarifas** define os preços de venda aos clientes e as associações de roteamento.
* **Prefixos** identifica os destinos usados na busca de tarifa.
* **Tarifas de provedores** registra os custos dos provedores para comparação e
  roteamento.
* **Tarifas personalizadas do usuário** substitui as tarifas padrão para clientes
  específicos.
* **Ofertas** configura pacotes, franquias e benefícios recorrentes.

Para os detalhes de cálculo, veja :doc:`Cálculo do preço <price_calculation>` e :doc:`Seleção de tarifa <find_rate>`.

DIDs e roteamento de entrada
----------------------------

* **DIDs** gerencia os números de entrada.
* **Destinos de DID** define para onde um número de entrada é entregue.
* **URAs** monta os menus de atendimento eletrônico.
* **Filas** e **Membros das filas** configuram a distribuição de central de
  atendimento.
* **Feriados** aplica o roteamento conforme a data.
* **Histórico de DIDs** e **Uso de DIDs** mostram as atribuições e o uso.

Troncos e roteamento de saída
-----------------------------

* **Troncos** configura as conexões com os provedores de voz.
* **Grupos de troncos** controla a ordem de roteamento e o failover entre troncos.
* **Tarifas de provedores** guarda o custo associado aos destinos do provedor.
* **Códigos SIP dos troncos** registra as respostas dos provedores usadas no
  roteamento e no diagnóstico.

O MBilling 8 usa PJSIP nas instalações novas. Leia :doc:`Novidades do MBilling 8 <whats_new_mb8>` antes de migrar configurações legadas do ``chan_sip``.

Campanhas e mensagens
---------------------

* **Campanhas** agenda operações de saída por voz, SMS ou WhatsApp.
* **Agendas** e **Números** organizam os destinatários das campanhas.
* **Pesquisas de campanha** coleta as respostas dos fluxos de campanha suportados.
* **Restrições de campanha** bloqueia os números que não podem ser contatados.
* **Relatórios de campanha** e **Painel de campanhas** mostram os resultados
  operacionais.

Para a configuração de mensagens empresariais e os requisitos de conformidade, veja :doc:`Campanhas no WhatsApp <whatsapp_campaign>`.

Relatórios e monitoramento
--------------------------

* **CDR** traz o registro detalhado das chamadas usado para investigar a tarifação.
* Os módulos de **Resumo** agregam o tráfego por dia, mês, usuário, tronco, DID,
  revenda ou call shop.
* **SIP Trace** captura a sinalização quando o módulo opcional está instalado.
* **Alarmes** e **Log de usuários** apoiam o monitoramento operacional e a auditoria.
* **Consumo por Plano** (customização Comunic) mostra, por ciclo, o valor
  recorrente, o saldo, a recarga e o valor a pagar de cada cliente com plano.

Administração do sistema
------------------------

* **Configuração** controla o comportamento global da plataforma.
* **Servidores** descreve os servidores de telefonia gerenciados pela instalação.
* **Grupos de usuários** e **Grupos de módulos** controlam o acesso às funções do
  painel.
* **API** gerencia as credenciais e permissões das integrações externas.
* **SMTP** e **Modelos de e-mail** controlam os e-mails administrativos enviados.
* **Firewall** expõe a gestão de controle de acesso suportada.
* **Serviços** gerencia os serviços recorrentes atribuídos aos clientes.

Use a ajuda de campo de cada módulo antes de gravar valores que você não conhece.
Para mudanças no sistema, faça backup do banco e da configuração e valide o
comportamento no servidor real.
