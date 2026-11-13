
.. _queue-id-user:

Usuário
-------

| Usuário dono da fila.




.. _queue-name:

Nome
----

| Nome da fila.




.. _queue-language:

Idioma
------

| Idioma da fila.




.. _queue-strategy:

Estratégia
----------

| Estratégia da fila.




.. _queue-ringinuse:

Ringinuse
---------

| Chamar ou não os agentes da fila que já estão em ligação.




.. _queue-timeout:

Tocar por
---------

| Por quanto tempo o telefone toca até desistir.




.. _queue-retry:

Tempo para outro agente
-----------------------

| Tempo em segundos até tentar a chamada de novo.




.. _queue-wrapuptime:

Tempo para outra chamada
------------------------

| Tempo em segundos até o agente poder receber outra chamada.




.. _queue-weight:

Peso
----

| Prioridade da fila.




.. _queue-periodic-announce:

Anúncio periódico
-----------------

| É possível criar um conjunto de anúncios periódicos separando por vírgulas os anúncios a tocar. Ex.: queue-periodic-announce,your-call-is-important,please-wait. Os arquivos precisam estar no diretório /var/lib/asterisk/sounds/.




.. _queue-periodic-announce-frequency:

Frequência
----------

| De quanto em quanto tempo tocar o anúncio periódico.




.. _queue-announce-position:

Anunciar posição
----------------

| Informa a posição na fila.




.. _queue-announce-holdtime:

Anunciar tempo de espera
------------------------

| Incluir o tempo de espera estimado nos anúncios de posição?




.. _queue-announce-frequency:

Frequência do anúncio
---------------------

| De quanto em quanto tempo anunciar a posição na fila e/ou o tempo de espera estimado a quem ligou. 0 = desligado.




.. _queue-joinempty:

Entrar com fila vazia
---------------------

| Aceita chamadas quando não há ninguém para atender.




.. _queue-leavewhenempty:

Sair quando vazia
-----------------

| Desliga as chamadas na fila quando não há ninguém para atender.




.. _queue-max-wait-time:

Tempo máximo de espera
----------------------

| Tempo máximo de espera na fila.




.. _queue-max-wait-time-action:

Ação no tempo máximo de espera
------------------------------

| Conta SIP, URA, FILA ou canal LOCAL para onde mandar quem ligou se o tempo máximo de espera for atingido. Use: SIP/conta_sip, QUEUE/nome_da_fila, IVR/nome_da_ura ou LOCAL/ramal@contexto.




.. _queue-ring-or-moh:

Toque ou música de espera
-------------------------

| Tocar música de espera ou tom de chamada enquanto o cliente está na fila.




.. _queue-musiconhold:

Áudio da música de espera
-------------------------

| Importa uma música de espera para esta fila.



