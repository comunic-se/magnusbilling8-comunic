.. _offer:

Pacotes gratuitos
=================

O que são pacotes gratuitos?
++++++++++++++++++++++++++++

Pacotes gratuitos servem para dar aos clientes uma quantidade de chamadas sem custo, por uma mensalidade ou sem custo nenhum.

Como configurar?
++++++++++++++++

A configuração dos pacotes gratuitos tem várias etapas.

1 - Crie o pacote.

	Veja a descrição de cada campo:

	* :ref:`offer-label`
	* :ref:`offer-packagetype`
	* :ref:`offer-freetimetocall`
	* :ref:`offer-billingtype`
	* :ref:`offer-price`


2 - Selecione as tarifas que quer incluir nos pacotes.

	É preciso informar quais prefixos entram nos pacotes gratuitos. Para isso, vá ao menu Tarifas, submenu Tarifas, clique na tarifa que quer incluir nos pacotes e marque a opção "Incluir nos pacotes gratuitos".


3 - Ative os pacotes gratuitos para os usuários.
	Vá ao menu Clientes, submenu Usuários, clique no cliente em que quer ativar o pacote e, na opção "Ativar pacote gratuito", selecione o pacote que quer ativar para ele.


Como funciona?
++++++++++++++

Vamos usar este exemplo:

Foi criado um pacote gratuito chamado ESPANHA FIXO, com 6000 segundos grátis, ou seja, 100 minutos, cobrança mensal e preço de USD 5,00.

Ele foi configurado para incluir nos pacotes gratuitos as tarifas de fixo da Espanha do plano Gold.

O pacote gratuito foi ativado no usuário 24315, e esse cliente foi colocado no plano Gold.

E deixamos o cliente 24315 com saldo de USD 10,00.


Processo feito pelo sistema:

O cliente 24315 liga para o número 551140040001; o sistema confere o plano do cliente e procura a tarifa mais adequada ao número discado, neste caso a tarifa 55114, prefixo de São Paulo.

Depois confere se essa tarifa tem a opção "Incluir nos pacotes gratuitos". Se tiver, como no nosso exemplo, o MagnusBilling confere se o cliente já usou os 100 minutos desde o dia da ativação, conforme a cobrança seja mensal ou semanal (no exemplo, mensal). Se os 100 minutos ainda não foram usados, o sistema deixa o cliente ligar mesmo com saldo 0. E, se o cliente tiver saldo, a chamada sai de graça.

Se a tarifa estiver incluída nos pacotes mas o cliente já tiver passado do limite do pacote, o MagnusBilling só libera a chamada se o cliente tiver crédito.

Continuando o exemplo, se o cliente discar qualquer outro número que não comece com 55114, só consegue ligar se tiver crédito. No nosso plano Gold, só o prefixo 55114 foi incluído nos pacotes.



Como a mensalidade é cobrada?
+++++++++++++++++++++++++++++

Usando o mesmo exemplo, e supondo que o plano foi ativado no dia 15, o sistema cobra automaticamente do crédito do cliente o valor do pacote, neste exemplo USD 5,00, todo dia 15.

No menu Configurações, submenu Configuração, há uma opção chamada "Notificação dos pacotes de oferta", que por padrão é 5 dias. Isso significa que, 5 dias antes do vencimento do plano, o MagnusBilling tenta cobrar o valor do pacote; no nosso exemplo, seria no dia 10.

Se o cliente não tiver crédito suficiente para o MagnusBilling descontar os USD 5,00, é enviado o e-mail "plan_unpaid".

O MagnusBilling tenta cobrar o valor do pacote gratuito até conseguir ou até o pacote vencer.

Se o cliente colocar crédito, ou já tiver crédito suficiente para o pagamento, o MagnusBilling marca o plano como pago por mais um mês, cria uma recarga no valor do plano e envia o e-mail "plan_paid".

Se chegar o dia 16 e o cliente ainda não tiver crédito suficiente, o plano é desativado na conta do usuário e é enviado o e-mail "plan_released".


Os e-mails podem ser encontrados e editados no menu Configurações, submenu Modelos de e-mail.


Onde ver o consumo de cada cliente?
+++++++++++++++++++++++++++++++++++

Todas as chamadas feitas usando um pacote entram no menu Tarifas, submenu Relatório de pacotes.



OBS.:
* Não é possível ativar mais de um pacote por cliente.
* Não é possível criar pacotes combinados, por exemplo, 100 minutos para fixo e 50 minutos para celular.
* As chamadas feitas usando pacotes são sempre arredondadas para cima em minutos, qualquer que seja o tempo mínimo e o bloco de tempo da tarifa.





Imagens de exemplo
++++++++++++++++++


Veja algumas imagens da configuração do nosso exemplo.


O pacote gratuito.

.. image :: img / package.png

Tarifas.

.. image :: img / Bundle-Rates.png

Mostrar a coluna "Incluir nos pacotes gratuitos".

.. image :: img / package-column-hidden.png

Ativação no usuário

.. image :: img / package-user.png

Relatório

.. image :: img / package-relatorio.png

Modelos de e-mail

.. image :: img / packages-emails.png
