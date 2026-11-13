.. _how-to-use-voucher:

Como usar o VOUCHER
===================

Para usar um voucher, o primeiro passo é criar os vouchers no menu Financeiro, submenu Voucher.

Veja a descrição de cada campo:

* :ref:`voucher-credit`
* :ref:`voucher-id-plan`
* :ref:`voucher-language`
* :ref:`voucher-prefix-local`
* :ref:`voucher-quantity`
* :ref:`voucher-tag`
* :ref:`voucher-voucher`


Depois de gerar os vouchers, é preciso dar permissão ao grupo de clientes para que possam ver e criar vouchers, como na imagem abaixo.

.. image:: img/voucher_permission.png
        :scale: 85%


Há três formas de usar um voucher.

1 - Pelo painel de um cliente já existente.

Os clientes que tiverem um voucher ainda não usado, e que pertençam a um grupo de clientes com permissão para ver e criar vouchers, podem entrar no painel, ir ao menu Voucher, clicar em Novo e informar o voucher. Se o voucher estiver correto, o sistema libera o crédito ao usuário.



2 - Por um DID.

Crie um DID e deixe sem destino, ou com destino Calling Card. Ao ligar para o DID, será pedido um número de PIN: informe o número do voucher. Um usuário novo é criado com as configurações do voucher, e o crédito é colocado na conta.


3 - Ligando de uma conta SIP para o código \*120

Ao ligar para o código \*120 e informar o número do voucher quando o PIN for pedido, o valor do voucher é colocado no usuário.




Nas 3 formas acima, é criada uma recarga para o cliente com o valor de crédito do voucher.

No menu Voucher do administrador aparecem o usuário que usou o voucher e a data de uso.
