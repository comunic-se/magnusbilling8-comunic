
.. _paid-sipTrace-head:

SIPTrace
========

O módulo **SIPTrace** permite capturar pacotes SIP direto na interface do MagnusBilling para ajudar a diagnosticar chamadas, registros e respostas dos troncos.

É um módulo pago. Para comprar, acesse:

`https://magnussolution.com/services/high-availability/siptrace-en.html <https://magnussolution.com/services/high-availability/siptrace-en.html>`_

A captura é pedida pelo usuário no painel. Um processo em segundo plano roda o ``ngrep`` com os dados pedidos e grava o resultado em:

``/var/www/html/mbilling/resources/reports/siptrace.log``

Quando o usuário atualiza o módulo, o sistema lê esse arquivo e mostra os pacotes capturados na grade.

.. image:: ../../img/paid_modules/siptrace-grid.png
   :alt: Grade do módulo SIPTrace


Quando usar
-----------

Use o SIPTrace para conferir, por exemplo:

* se uma chamada está chegando ao servidor;
* se o servidor está mandando a chamada para o tronco;
* qual resposta SIP o tronco devolveu, como ``403``, ``404``, ``480``, ``486``, ``500`` ou ``503``;
* se um pedido ``REGISTER`` está chegando ao servidor;
* se há diferença entre a perna de entrada e a perna de saída da chamada;
* se o Call-ID de uma chamada tem todos os pacotes esperados.


Iniciar uma captura
-------------------

1. Abra o módulo **SIPTrace**.
2. Clique em **Iniciar captura**.
3. Preencha os campos da captura.
4. Clique de novo em **Iniciar captura** na janela de filtro.
5. Espere o tempo configurado.
6. Clique em **Atualizar** na grade para ver os pacotes capturados.

Enquanto uma captura está ativa, o sistema não deixa iniciar outra. Espere a captura terminar ou clique em **Parar captura**.

.. image:: ../../img/paid_modules/siptrace-start-capture.png
   :alt: Janela de início de captura do SIPTrace


Campos da captura
-----------------

Tempo do filtro
~~~~~~~~~~~~~~~

Tempo, em segundos, em que a captura fica ativa.

O valor precisa ser numérico. O mínimo é ``5`` e o máximo é ``300``.


Porta
~~~~~

Porta SIP monitorada.

Normalmente a porta é ``5060``. Em instalações que usam outra porta SIP, informe a porta correspondente.

O valor precisa ser numérico e ficar entre ``1`` e ``65535``.


Filtro
~~~~~~

Texto usado para filtrar os pacotes capturados.

Exemplos comuns:

* IP do cliente;
* IP do tronco;
* número discado;
* conta SIP;
* parte do Call-ID.

Use filtros específicos sempre que possível. Quanto mais genérico o filtro, maior o arquivo gerado e mais difícil analisar o resultado.


Atualizar a grade
-----------------

Depois de iniciar a captura, clique em **Atualizar** para carregar os pacotes gravados no arquivo ``siptrace.log``.

A grade mostra as principais informações de cada pacote:

* **Método**: método ou resposta SIP, como ``INVITE``, ``ACK``, ``BYE``, ``100 Trying``, ``180 Ringing`` ou ``503 Service Unavailable``;
* **Call ID**: identificador SIP da chamada ou da transação;
* **SIP To**: destino mostrado no cabeçalho ``To``;
* **Origem**: origem do pacote;
* **Destino**: destino do pacote;
* **Head**: corpo completo do pacote SIP, usado internamente e também na análise detalhada.


Filtrar na grade
----------------

Os filtros da grade ajudam a achar pacotes específicos dentro do arquivo capturado.

Você pode filtrar por:

* método ou resposta SIP;
* Call-ID;
* IP de origem;
* IP de destino;
* cabeçalho ``To``.

Para analisar uma chamada, o melhor filtro costuma ser o **Call ID**, porque todos os pacotes da mesma chamada usam o mesmo identificador.


Ver os detalhes da chamada
--------------------------

Para abrir a visão detalhada:

1. Selecione um ou mais registros na grade.
2. Clique em **Detalhes**.

O sistema abre uma janela com os pacotes do Call-ID selecionado, numa visão parecida com a do ``sngrep``.

Você pode selecionar até ``3`` registros de cada vez. Isso permite comparar chamadas ou pernas diferentes sem deixar a tela pesada demais.

Na tela de detalhes:

* cada linha é um pacote SIP;
* as setas indicam o sentido do pacote entre origem e destino;
* respostas ``1xx`` e ``2xx`` indicam andamento ou sucesso;
* respostas ``3xx``, ``4xx``, ``5xx`` e ``6xx`` indicam redirecionamento, erro ou recusa;
* pacotes com SDP mostram as informações de mídia, como codecs e IP/porta do áudio;
* ao clicar num pacote, aparece o corpo completo da mensagem SIP.


Exportar o log
--------------

Clique em **Exportar arquivo** para baixar o arquivo ``siptrace.log``.

Use esta opção quando precisar mandar a captura ao suporte ou analisar o conteúdo em outra ferramenta.


Parar uma captura
-----------------

Clique em **Parar captura** para interromper o pedido de captura ativo.

Use esta opção quando o filtro estiver errado ou quando não precisar esperar o tempo configurado.


Apagar o log
------------

Clique em **Apagar** para apagar o arquivo de log do SIPTrace.

Esta ação remove o conteúdo capturado antes. Antes de apagar, exporte o arquivo se precisar guardar a análise.


Como interpretar as respostas comuns
------------------------------------

``100 Trying``
    O equipamento recebeu o ``INVITE`` e começou a processar a chamada.

``180 Ringing``
    O destino está tocando.

``183 Session Progress``
    O destino mandou andamento da chamada. Pode trazer SDP e early media.

``200 OK``
    O pedido foi aceito. Em chamadas, normalmente significa que a chamada foi atendida.

``403 Forbidden``
    A chamada foi recusada por permissão, autenticação, roteamento ou política do provedor.

``404 Not Found``
    O destino ou a rota não foi encontrado.

``480 Temporarily Unavailable``
    O destino está temporariamente indisponível.

``486 Busy Here``
    O destino está ocupado.

``500 Server Internal Error``
    Erro interno no servidor ou no provedor.

``503 Service Unavailable``
    O serviço ou a rota está indisponível. Pode indicar falha no tronco, limite, indisponibilidade ou problema temporário no provedor.


Boas práticas
-------------

* Use sempre o filtro mais específico possível.
* Prefira capturas curtas, entre ``30`` e ``60`` segundos.
* Em chamadas, filtre pelo número discado ou pelo IP do cliente/tronco.
* Depois de achar o pacote na grade, use **Detalhes** para analisar o Call-ID completo.
* Compare a perna de entrada e a perna de saída da chamada.
* Apague ou exporte os logs antigos para evitar arquivos muito grandes.


Limitações
----------

O SIPTrace só captura o tráfego que passa pela interface e pela porta monitoradas. Se o pacote não chegou ao servidor, ele não aparece no log.
