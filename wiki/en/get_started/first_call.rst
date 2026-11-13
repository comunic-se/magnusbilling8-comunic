Fazendo a primeira chamada
==========================

Este guia cria um cliente, um endpoint SIP, um plano, uma rota de provedor, uma
tarifa e um saldo inicial para uma chamada de teste controlada.

Antes de começar
----------------

Confirme que as conferências de :doc:`Instalação <quick_install>` passaram e que
você tem credenciais válidas de tronco de um provedor de voz. Use um destino de
teste para o qual você tenha autorização para ligar.

1. Crie um cliente e um plano
-----------------------------

Entre no MagnusBilling e abra **Clientes > Usuários > Novo**. Crie o cliente e
selecione o grupo de clientes.

.. image:: ../img/users_img.png
   :scale: 80%
   :alt: Menu Usuários do MagnusBilling

.. image:: ../img/users_newimg.png
   :scale: 80%
   :alt: Criando um usuário no MagnusBilling

Abra **Tarifas > Planos > Novo** e crie um plano. Volte ao formulário do usuário e
associe esse plano ao cliente.

.. image:: ../img/user_clientimg.png
   :scale: 80%
   :alt: Selecionando o grupo de clientes

.. image:: ../img/user_selectplan2.png
   :scale: 80%
   :alt: Associando um plano a um usuário

O MagnusBilling normalmente cria uma conta SIP para o cliente novo. Abra o módulo
Usuários SIP e anote o usuário e a senha gerados.

2. Registre o endpoint SIP
--------------------------

Configure um cliente SIP com as credenciais geradas. Use o IP do servidor
MagnusBilling como domínio. As instalações novas do MBilling 8 usam PJSIP e escutam
na porta UDP ``5060`` por padrão, a menos que o administrador tenha mudado a
configuração de transporte.

.. image:: ../img/zoiper_config.png
   :scale: 80%
   :alt: Exemplo de configuração de cliente SIP

Confirme o status do endpoint no painel e com os comandos PJSIP do Asterisk no
servidor. Não continue até o registro dar certo.

3. Configure a rota do provedor
-------------------------------

1. Abra **Rotas > Provedores** e crie o registro do provedor.
2. Crie um tronco com as credenciais PJSIP e as informações de roteamento
   fornecidas pelo provedor.
3. Crie um grupo de troncos e acrescente o tronco na ordem de roteamento desejada.

Não copie um peer legado do ``chan_sip`` sem mudanças. Traduza as configurações do
provedor para transporte, endpoint, autenticação, AOR, identificação, codec e
registro do PJSIP, conforme for preciso.

4. Configure o preço dos destinos
---------------------------------

Crie o prefixo de destino e a tarifa em **Tarifas** e depois associe a tarifa ao
plano do cliente e ao grupo de troncos correto. Leia os guias
:doc:`Seleção de tarifa <../find_rate>` e :doc:`Cálculo do preço <../price_calculation>` antes de usar tarifas de produção.

5. Coloque crédito de teste e ligue
-----------------------------------

Abra **Faturamento > Recargas** e coloque um pequeno saldo de teste no cliente.
Faça uma chamada a partir do endpoint registrado e confira se:

* o tronco esperado foi escolhido;
* o áudio nos dois sentidos e o DTMF funcionam;
* a chamada aparece em Chamadas online enquanto está ativa;
* o CDR concluído tem o destino, a duração, o preço de compra, o preço de venda e
  a causa de desligamento esperados;
* o saldo do cliente mudou no valor esperado.

Se o registro der certo mas a chamada falhar, investigue separadamente a
autenticação, o formato do número, a escolha da tarifa, o roteamento do tronco, as
respostas do provedor e o firewall/NAT. Para problemas de áudio, veja o
:doc:`guia de solução de problemas de áudio <../admin_guide/troubleshooting_no_audio>`.
