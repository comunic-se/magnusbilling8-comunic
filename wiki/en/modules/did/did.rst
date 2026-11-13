
.. _did-did:

DID
---

| Número exato que chega do contexto no Asterisk. Recomendamos usar sempre o formato E164. Também é possível criar intervalos. Exemplo: 13605040001-13605040009 cria os DIDs de 13605040001 até 13605040009.




.. _did-country:

País
----

| País associado ao DID, usado para identificar e organizar o número.




.. _did-record-call:

Gravar chamada
--------------

| Grava as chamadas deste DID, qualquer que seja o destino.




.. _did-activated:

Status
------

| Só números ativos recebem chamadas.




.. _did-callerid:

Nome do CallerID
----------------

| Use este campo para definir o nome do CallerID ou deixe em branco para usar o CallerID recebido do provedor do DID.




.. _did-connection-charge:

Preço de ativação
-----------------

| Custo de ativação. Este valor é descontado do cliente no momento em que o DID é associado ao usuário.




.. _did-fixrate:

Preço mensal
------------

| Preço mensal. Este valor é descontado automaticamente todo mês do saldo do usuário. Se o cliente não tiver crédito suficiente, o DID é cancelado automaticamente.




.. _did-connection-sell:

Taxa de conexão
---------------

| Valor cobrado em cada chamada. Basta atender a chamada para este valor ser descontado.




.. _did-minimal-time-buy:

Tempo mínimo de cobrança
------------------------

| Duração mínima de chamada cobrada pelo provedor para este DID.




.. _did-buyrateinitblock:

Bloco inicial de compra
-----------------------

| Bloco inicial de cobrança usado para calcular o custo do provedor nas chamadas recebidas neste DID.




.. _did-buyrateincrement:

Incremento de compra
--------------------

| Incremento de cobrança usado depois do bloco inicial para calcular o custo do provedor deste DID.




.. _did-minimal-time-charge:

Tempo mínimo de cobrança
------------------------

| Tempo mínimo para tarifar o DID. Se estiver em 3, chamadas mais curtas não são cobradas.




.. _did-initblock:

Bloco inicial
-------------

| Tempo mínimo em segundos a cobrar. Se estiver em 30 e a chamada durar 10, é cobrada como 30.




.. _did-increment:

Bloco de cobrança
-----------------

| Define o bloco, em segundos, em que o tempo cobrado é incrementado. Se estiver em 6 e a chamada durar 32, é cobrada como 36.




.. _did-charge-of:

Cobrar de
---------

| Usuário que paga o custo do DID.




.. _did-calllimit:

Limite de canais
----------------

| Máximo de chamadas simultâneas neste DID.




.. _did-id-server:

Servidor
--------

| Servidor que recebe e processa as chamadas deste DID.




.. _did-description:

Descrição
---------

| Informe aqui o destino.




.. _did-expression-1:

Expressão regular
-----------------

| Expressão regular para tarifar o DID conforme quem liga.
| Vamos analisar um exemplo real:
|     Suponha que queremos cobrar 0,10 quando a chamada vier de um fixo, 0,20 quando vier de um celular e bloquear qualquer outro formato.
|     Neste exemplo, criamos regras para identificar o CallerID no formato 0 + DDD + número, DDD + número ou 55 + DDD + número.
|
|     Veja na imagem como fica o resultado:
|
|     .. image:: ../../img/did_regex.png
   :scale: 100%
|
|     Expressão regular para celular
|     ^[1-9][0-9]9\\d{8}$\|^0[1-9][0-9]9\\d{8}$\|^55[1-9][0-9]9\\d{8}$
|
|     Expressão regular para fixo
|     ^[1-9][0-9]\\d{8}$\|^0[1-9][0-9]\\d{8}$\|^55[1-9][0-9]\\d{8}$
|
|
|




.. _did-buy-rate-1:

Preço de compra por minuto
--------------------------

| Preço de compra por minuto do provedor no primeiro intervalo de cobrança das chamadas recebidas neste DID.




.. _did-selling-rate-1:

Preço de venda por minuto
-------------------------

| Preço por minuto se o número atender à expressão regular acima.




.. _did-block-expression-1:

Bloquear chamadas desta expressão
---------------------------------

| Coloque sim para bloquear as chamadas que atendem à expressão regular acima.




.. _did-send-to-callback-1:

Mandar a chamada para o callback
--------------------------------

| Manda esta chamada para o CallBack se ela atender à expressão regular acima.




.. _did-expression-2:

Expressão regular
-----------------

| Igual à primeira expressão. Veja mais detalhes no link `https://wiki.magnusbilling.org/en/source/modules/did/did.html#did-expression-1.  <https://wiki.magnusbilling.org/en/source/modules/did/did.html#did-expression-1.>`_.




.. _did-buy-rate-2:

Preço de compra por minuto
--------------------------

| Preço de compra por minuto do provedor no segundo intervalo de cobrança das chamadas recebidas neste DID.




.. _did-selling-rate-2:

Preço de venda por minuto
-------------------------

| Preço por minuto se o número atender à expressão regular acima.




.. _did-block-expression-2:

Bloquear chamadas desta expressão
---------------------------------

| Coloque sim para bloquear as chamadas que atendem à expressão regular acima.




.. _did-send-to-callback-2:

Mandar a chamada para o callback
--------------------------------

| Manda esta chamada para o CallBack se ela atender à expressão regular acima.




.. _did-expression-3:

Expressão regular
-----------------

| Igual à primeira expressão. Veja mais detalhes no link `https://wiki.magnusbilling.org/en/source/modules/did/did.html#did-expression-1.  <https://wiki.magnusbilling.org/en/source/modules/did/did.html#did-expression-1.>`_.




.. _did-buy-rate-3:

Preço de compra por minuto
--------------------------

| Preço de compra por minuto do provedor no terceiro intervalo de cobrança das chamadas recebidas neste DID.




.. _did-selling-rate-3:

Preço de venda por minuto
-------------------------

| Preço por minuto se o número atender à expressão regular acima.




.. _did-block-expression-3:

Bloquear chamadas desta expressão
---------------------------------

| Coloque sim para bloquear as chamadas que atendem à expressão regular acima.




.. _did-send-to-callback-3:

Mandar a chamada para o callback
--------------------------------

| Manda esta chamada para o CallBack se ela atender à expressão regular acima.




.. _did-cbr:

CallBack pro
------------

| Ativa o CallBack Pro.




.. _did-cbr-ua:

Usar áudio
----------

| Toca um áudio.




.. _did-cbr-total-try:

Máximo de tentativas
--------------------

| Quantas vezes o sistema tenta retornar a chamada.




.. _did-cbr-time-try:

Intervalo entre tentativas
--------------------------

| Intervalo entre as tentativas, em minutos.




.. _did-cbr-em:

Early media
-----------

| Toca um áudio antes de a chamada ser atendida. O provedor do DID precisa permitir early media.




.. _did-TimeOfDay-monFri:

Seg-Sex
-------

| Exemplo: se a sua empresa só retorna a chamada quando ela chega entre 09:00-12:00 e 14:00-18:00 de segunda a sexta, nesse intervalo toca o áudio do expediente e depois a chamada é retornada. Você pode usar vários intervalos separados por \|.




.. _did-TimeOfDay-sat:

Sáb
---

| O mesmo, para sábado.




.. _did-TimeOfDay-sun:

Dom
---

| O mesmo, para domingo.




.. _did-workaudio:

Áudio do expediente
-------------------

| Áudio tocado quando uma chamada chega dentro do intervalo.




.. _did-noworkaudio:

Áudio fora do expediente
------------------------

| Áudio tocado quando uma chamada chega fora do intervalo.




.. _did-agent-client-rate-2:

Preço de venda por minuto
-------------------------

| Preço de venda por minuto cobrado do cliente da revenda no segundo intervalo de cobrança das chamadas recebidas neste DID.




.. _did-agent-client-rate-3:

Preço de venda por minuto
-------------------------

| Preço de venda por minuto cobrado do cliente da revenda no terceiro intervalo de cobrança das chamadas recebidas neste DID.




.. _did-agent-client-rate-1:

Preço de venda por minuto
-------------------------

| Preço de venda por minuto cobrado do cliente da revenda no primeiro intervalo de cobrança das chamadas recebidas neste DID.



