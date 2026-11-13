
.. _user-username:

Usuário
-------

| Usuário usado para entrar no painel.




.. _user-password:

Senha
-----

| Senha usada para entrar no painel.




.. _user-id-group:

Grupo
-----

| Há 3 grupos: administrador, revenda e cliente. Você pode criar mais ou editar qualquer um deles. Cada grupo pode ter permissões próprias. Veja o menu Configurações -> Grupo de usuários.




.. _user-id-group-agent:

Grupo para os usuários da revenda
---------------------------------

| Selecione o grupo usado pelos clientes desta revenda.




.. _user-id-plan:

Plano
-----

| Plano usado para cobrar os clientes.




.. _user-language:

Idioma
------

| Idioma. É usado em algumas funções do sistema, mas não define o idioma do painel.




.. _user-prefix-local:

Regras de prefixo
-----------------

| Regras de prefixo. Veja mais detalhes no link `https://www.magnusbilling.org/local_prefix  <https://www.magnusbilling.org/local_prefix>`_.




.. _user-active:

Ativo
-----

| Só usuários ativos conseguem entrar no painel e fazer chamadas.




.. _user-country:

País
----

| Usado no CallBack por CID. O código do país é colocado antes do CID para convertê-lo para E164.




.. _user-id-offer:

Ativar oferta
-------------

| Usado para dar minutos grátis. É preciso informar as tarifas que pertencem aos pacotes gratuitos.




.. _user-cpslimit:

Limite de CPS
-------------

| Limite de CPS (chamadas por segundo) deste cliente. As chamadas acima do limite recebem CONGESTION.




.. _user-description:

Descrição
---------

| Observações opcionais sobre este usuário, visíveis só para administradores e revendas com acesso.




.. _user-company-website:

Site da empresa
---------------

| Site da empresa.\|Também é usado para personalizar o painel da revenda. Para revenda, informe o domínio sem http nem www.




.. _user-company-name:

Nome da empresa
---------------

| Nome da empresa. Também é usado para personalizar o painel da revenda.\|Se for revenda, este nome aparece na tela de login. Para a personalização funcionar, é preciso informar o site da empresa e acessar pelo domínio da revenda.




.. _user-commercial-name:

Nome comercial
--------------

| Nome fantasia.




.. _user-state-number:

Inscrição estadual
------------------

| Inscrição estadual.




.. _user-lastname:

Sobrenome
---------

| Sobrenome.




.. _user-firstname:

Nome
----

| Nome.




.. _user-city:

Cidade
------

| Cidade.




.. _user-state:

Estado
------

| Estado.




.. _user-address:

Endereço
--------

| Endereço.




.. _user-neighborhood:

Bairro
------

| Bairro.




.. _user-zipcode:

CEP
---

| CEP.




.. _user-phone:

Telefone
--------

| Telefone fixo.




.. _user-mobile:

Celular
-------

| Celular.




.. _user-email:

E-mail
------

| E-mail; necessário para enviar as notificações do sistema.




.. _user-email2:

E-mail
------

| E-mail secundário deste usuário.




.. _user-doc:

Documento
---------

| Documento do cliente (CPF/CNPJ).




.. _user-vat:

VAT
---

| Usado em algumas formas de pagamento.




.. _user-contract-value:

Valor do contrato
-----------------

| Valor mensal do contrato ou valor fixo associado a este usuário.




.. _user-dist:

DIST
----

| Código DIST usado em integrações brasileiras de cobrança ou numeração.




.. _user-typepaid:

Tipo de pagamento
-----------------

| Clientes pós-pagos podem ficar com saldo negativo até o limite de crédito informado no campo abaixo.




.. _user-credit-notification-daily:

Notificação diária de crédito
-----------------------------

| Ative para o cliente receber por e-mail a notificação diária do saldo. Você pode personalizar o e-mail no menu Configurações, submenu Modelos de e-mail.




.. _user-creditlimit:

Limite de crédito
-----------------

| Se o usuário for pós-pago, poderá fazer chamadas até atingir este limite.




.. _user-credit-notification:

Aviso de crédito
----------------

| Se o crédito do cliente ficar abaixo deste valor, o MagnusBilling manda um e-mail avisando que o crédito está baixo. É NECESSÁRIO TER UM SERVIDOR SMTP CADASTRADO NO MENU DE CONFIGURAÇÕES.




.. _user-email-services:

E-mail de notificação de serviços
---------------------------------

| Endereço de e-mail usado para enviar as notificações de serviços a este usuário.




.. _user-email-did:

E-mail de notificação de DID
----------------------------

| Endereço de e-mail usado para enviar as notificações de reserva, renovação e vencimento de DID.




.. _user-enableexpire:

Ativar vencimento
-----------------

| Ativa o vencimento. É preciso informar a data no campo "Data de vencimento".




.. _user-expirationdate:

Data de vencimento
------------------

| Data a partir da qual o usuário não consegue mais fazer chamadas.




.. _user-calllimit:

Limite de chamadas
------------------

| Quantidade de chamadas simultâneas permitidas para este cliente.




.. _user-inbound-call-limit:

Limite de chamadas recebidas
----------------------------

| Número máximo de chamadas recebidas simultâneas permitidas para este usuário.




.. _user-mix-monitor-format:

Formato da gravação
-------------------

| Formato usado para gravar as chamadas.




.. _user-callshop:

Callshop
--------

| Ativa o módulo CallShop. Só ative se realmente for usar. É preciso dar permissão ao grupo selecionado.




.. _user-disk-space:

Espaço em disco
---------------

| Informe o espaço em disco disponível para gravações, em GB. Use -1 para não ter limite. É preciso colocar no cron o comando php /var/www/html/mbilling/cron.php UserDiskSpace.




.. _user-sipaccountlimit:

Limite de contas SIP
--------------------

| Quantidade de contas VoIP permitidas para este usuário. É preciso dar permissão ao grupo para criar contas VoIP.




.. _user-callingcard-pin:

PIN do CallingCard
------------------

| Usado para autenticar no CallingCard.




.. _user-restriction:

Restrição
---------

| Usado para restringir a discagem. Cadastre os números no menu Usuários -> Números restritos.




.. _user-restriction-use:

Usar
----

| Qual número é usado para conferir a restrição. Vale só para chamadas de saída.




.. _user-transfer-international-profit:

Lucro
-----

| Função não disponível no Brasil. É usada só para recargas de celular em alguns países.




.. _user-transfer-flexiload-profit:

Lucro
-----

| Função não disponível no Brasil. É usada só para recargas de celular em alguns países.




.. _user-transfer-bkash-profit:

Lucro
-----

| Função não disponível no Brasil. É usada só para recargas de celular em alguns países.




.. _user-transfer-dbbl-rocket:

Ativar DBBL/Rocket
------------------

| Função não disponível no Brasil. É usada só para recargas de celular em alguns países.




.. _user-transfer-dbbl-rocket-profit:

Lucro
-----

| Função não disponível no Brasil. É usada só para recargas de celular em alguns países.




.. _user-transfer-show-selling-price:

Mostrar preço de venda
----------------------

| Função não disponível no Brasil. É usada só para recargas de celular em alguns países.



