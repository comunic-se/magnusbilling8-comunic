
.. _iax-id-user:

Usuário
-------

| Usuário dono da conta IAX.




.. _iax-username:

Usuário IAX
-----------

| Usuário usado para autenticar no softphone.




.. _iax-secret:

Senha IAX
---------

| Senha usada para autenticar no softphone.




.. _iax-callerid:

CallerID
--------

| CallerID mostrado no destino. Em chamadas externas, o provedor precisa permitir o CLI para a identificação aparecer corretamente no destino.




.. _iax-disallow:

Disallow
--------

| Permite desativar codecs. Para desativar todos e deixar disponíveis ao usuário só os selecionados abaixo, use "Usar todos".




.. _iax-allow:

Codec
-----

| Codecs aceitos.




.. _iax-host:

Host
----

| "Dynamic" permite registrar esta conta a partir de qualquer IP. Para autenticar por IP, informe aqui o IP do cliente, deixe a senha em branco e coloque insecure em port/invite na aba Informações adicionais.




.. _iax-nat:

NAT
---

| O cliente está atrás de NAT. Veja mais detalhes no link `https://www.voip-info.org/asterisk-sip-nat/.  <https://www.voip-info.org/asterisk-sip-nat/.>`_.




.. _iax-context:

Contexto
--------

| Contexto do Asterisk onde as chamadas desta conta são processadas. O padrão é "billing". Só altere se você entender o dialplan do Asterisk.




.. _iax-qualify:

Qualify
-------

| Envia pacotes SIP OPTIONS para conferir se o peer está online.
| Sintaxe:
|
| qualify = xxx \| no \| yes
|
| XXX é o número de milissegundos usado como tempo limite. Se o valor for "yes", o Asterisk usa o tempo configurado no sip.conf. O padrão comum é 2 segundos.
|
| Com o qualify ativado, o Asterisk envia pacotes OPTIONS regularmente para conferir se o aparelho continua online.
| Se o aparelho não responder no tempo configurado, o Asterisk o considera offline para as próximas chamadas.
|
| Esse status pode ser conferido com o comando "sip show peer XXXX". O Asterisk só mostra o status do qualify quando o peer tem qualify ativado.




.. _iax-dtmfmode:

Dtmfmode
--------

| Modo DTMF usado por esta conta. Veja mais detalhes no link `https://www.voip-info.org/asterisk-sip-dtmfmode/.  <https://www.voip-info.org/asterisk-sip-dtmfmode/.>`_.




.. _iax-insecure:

Insecure
--------

| Se o host for dinâmico, esta opção precisa estar em no. Para autenticação por IP, use port. Veja mais detalhes no link `https://www.voip-info.org/asterisk-sip-insecure/.  <https://www.voip-info.org/asterisk-sip-insecure/.>`_.




.. _iax-type:

Tipo
----

| O tipo padrão é "friend", que permite à conta fazer e receber chamadas. Veja mais detalhes no link `https://www.voip-info.org/asterisk-sip-type/.  <https://www.voip-info.org/asterisk-sip-type/.>`_.




.. _iax-calllimit:

Limite de chamadas
------------------

| Total de chamadas simultâneas permitidas para esta conta IAX.



