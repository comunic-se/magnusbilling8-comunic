
.. _diddestination-id-did:

DID
---

| Selecione o DID para o qual quer criar um destino novo.




.. _diddestination-id-user:

Usuário
-------

| Usuário que será o dono deste DID.




.. _diddestination-activated:

Status
------

| Só os destinos ativos são usados.




.. _diddestination-priority:

Prioridade
----------

| Você pode criar até 5 destinos para o DID. Se uma tentativa der erro, o MagnusBilling tenta mandar a chamada para o próximo destino disponível pela prioridade. Só funciona com o tipo "Chamada SIP".




.. _diddestination-voip-call:

Tipo
----

| Tipo de destino.




.. _diddestination-destination:

Destino
-------

| Informe aqui o destino.




.. _diddestination-id-ivr:

URA
---

| Selecione uma URA para onde mandar a chamada. A URA também precisa pertencer ao dono do DID.




.. _diddestination-id-queue:

Fila
----

| Selecione uma fila para onde mandar a chamada. A fila também precisa pertencer ao dono do DID.




.. _diddestination-id-sip:

Usuário SIP
-----------

| Selecione um usuário SIP para onde mandar a chamada. O usuário SIP também precisa pertencer ao dono do DID.




.. _diddestination-context:

Contexto
--------

| Neste campo você pode usar um contexto no formato aceito pelo Asterisk.
| Exemplo:
|
| _X. => 1,Dial(SIP/sipaccount,45)
| same => n,Goto(s-\${DIALSTATUS},1)
|
|
| exten => s-NOANSWER,1,Hangup
| exten => s-CONGESTION,1,Congestion
| exten => s-CANCEL,1,Hangup
| exten => s-BUSY,1,Busy
| exten => s-CHANUNAVAIL,1,SetCallerId(4545454545)
| exten => s-CHANUNAVAIL,2,Dial(SIP/sipaccount2,,T)
|
|
| NÃO dê nome ao contexto, porque o nome é definido automaticamente como [did-numero-do-did].
|
| Você pode ver o contexto em /etc/asterisk/extensions_magnus_did.conf.
|
|



