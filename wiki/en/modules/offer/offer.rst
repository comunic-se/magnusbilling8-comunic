
.. _offer-label:

Nome
----

| Nome do pacote gratuito.




.. _offer-packagetype:

Tipo de pacote
--------------

| Tipo de pacote. Há 3 tipos: chamadas ilimitadas, chamadas grátis ou segundos grátis.




.. _offer-freetimetocall:

Tempo grátis para ligar
-----------------------

| Neste campo se configura a quantidade disponível no pacote.
| Exemplo:
| \* Chamadas ilimitadas: o campo fica em branco, porque o cliente pode ligar sem controle.
| \* Chamadas grátis: informe a quantidade de chamadas grátis que quer dar.
| \* Segundos grátis: informe a quantidade de segundos que o cliente pode usar.




.. _offer-billingtype:

Tipo de cobrança
----------------

| Período usado para calcular o pacote.
|  Veja a descrição:
| \* Mensal: o sistema confere, a partir do dia da ativação do plano + 30 dias, se o cliente atingiu o limite do pacote.
| \* Semanal: o sistema confere, a partir do dia da ativação do plano + 7 dias, se o cliente atingiu o limite do pacote.




.. _offer-price:

Preço
-----

| Preço cobrado mensalmente do cliente.
| Se no dia do vencimento o cliente não tiver saldo suficiente para pagar o pacote, o MagnusBilling cancela o pacote automaticamente.
|
| No menu Configurações, Ajustes, há a opção Package Offer Notification: é quantos dias antes do vencimento do pacote o sistema tenta cobrar a assinatura; se o cliente não tiver saldo, o MagnusBilling manda um e-mail avisando a falta de saldo.
|
| O e-mail pode ser editado no menu Modelos de e-mail, tipo plan_unpaid, assunto "Aviso de vencimento do plano mensal".
|
| Para enviar e-mails é preciso configurar o SMTP no menu SMTP.
|
| Para entender como funcionam os pacotes gratuitos: https://wiki.magnusbilling.org/en/source/offer.html.




.. _offer-initblock:

Bloco inicial
-------------

| Tempo mínimo em segundos para vender. Este valor substitui as tarifas do plano do cliente.




.. _offer-billingblock:

Bloco de cobrança
-----------------

| Define como o tempo é incrementado depois do mínimo. Este valor substitui as tarifas do plano do cliente.




.. _offer-minimal-time-charge:

Tempo mínimo de cobrança
------------------------

| Tempo mínimo para tarifar. Se estiver em 3, só são tarifadas as chamadas com 3 segundos ou mais.



