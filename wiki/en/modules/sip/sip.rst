
.. _sip-id-user:

Usuário
-------

| Usuário ao qual esta conta SIP está associada.




.. _sip-defaultuser:

Usuário SIP
-----------

| Usuário para entrar num softphone ou em qualquer aparelho SIP.




.. _sip-secret:

Senha SIP
---------

| Senha para entrar num softphone ou em qualquer aparelho SIP.




.. _sip-callerid:

CallerID
--------

| Número de identificação (Caller ID) mostrado no destino. O tronco precisa aceitar CLI.




.. _sip-alias:

Alias
-----

| Apelido para discar entre contas SIP do mesmo AccountCode (empresa).




.. _sip-disallow:

Disallow
--------

| Desativa todos os codecs; depois selecione abaixo os codecs a liberar para o usuário.




.. _sip-allow:

Codec
-----

| Selecione os codecs aceitos.




.. _sip-host:

Host
----

| "Dynamic" permite ao usuário registrar a conta a partir de qualquer IP. Para autenticar o usuário por IP, coloque aqui o IP do cliente, deixe a senha em branco e coloque "insecure" em port/invite na aba Informações adicionais.




.. _sip-sip-group:

Grupo
-----

| Quando uma chamada de DID ou de campanha é enviada a um grupo, todos os usuários SIP do grupo são chamados. Os grupos podem ter qualquer nome.
|
|
| Também é usado para capturar chamadas com \*8; é preciso configurar a opção "pickupexten = \*8" no arquivo "features.conf".
|




.. _sip-videosupport:

Videosupport
------------

| Ativa chamadas de vídeo.




.. _sip-block-call-reg:

Bloquear chamadas por regex
---------------------------

| Bloqueia chamadas usando REGEX. Para bloquear chamadas para celulares, coloque ^55\\d\\d9. Veja mais detalhes no link `https://regex101.com.  <https://regex101.com.>`_.




.. _sip-record-call:

Gravar chamada
--------------

| Grava as chamadas deste usuário SIP.




.. _sip-techprefix:

Tech prefix
-----------

| Útil quando é preciso autenticar por IP mais de um cliente que usa o mesmo IP. Comum em PBX multiempresa.




.. _sip-cnl:

Zona CNL
--------

| Zona CNL usada nas regras brasileiras de numeração e roteamento deste usuário SIP.




.. _sip-description:

Descrição
---------

| Descrição opcional para identificar este usuário SIP nos relatórios e nas telas de administração.




.. _sip-nat:

NAT
---

| NAT. Veja mais detalhes no link `https://www.voip-info.org/asterisk-sip-nat/  <https://www.voip-info.org/asterisk-sip-nat/>`_.




.. _sip-directmedia:

Directmedia
-----------

| Se ativado, o Asterisk tenta redirecionar o fluxo de mídia RTP para ir direto de quem liga para quem recebe.




.. _sip-qualify:

Qualify
-------

| Envia pacotes SIP OPTIONS para conferir se o usuário está online.
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




.. _sip-id-trunk-group:

Grupos de troncos
-----------------

| :::::::ATENÇÃO::::::. Ao selecionar aqui um grupo de troncos, o grupo de troncos das tarifas é ignorado e este grupo é sempre usado. Só selecione um grupo aqui se quiser mesmo que todas as chamadas deste usuário SIP saiam por ele.




.. _sip-context:

Contexto
--------

| Contexto em que a chamada é processada; o padrão é "billing". Só altere se conhecer o Asterisk.




.. _sip-dtmfmode:

Dtmfmode
--------

| Modo DTMF usado por este usuário SIP. Veja mais detalhes no link `https://www.voip-info.org/asterisk-sip-dtmfmode/.  <https://www.voip-info.org/asterisk-sip-dtmfmode/.>`_.




.. _sip-insecure:

Insecure
--------

| Precisa estar em "NO" quando o host é dinâmico. Para autenticação por IP, mude para port,invite.




.. _sip-deny:

Deny
----

| Permite limitar o tráfego SIP de um IP ou de uma rede.




.. _sip-permit:

Permit
------

| Permite liberar o tráfego SIP de um IP ou de uma rede.




.. _sip-type:

Tipo
----

| O tipo padrão é "friend", que permite ao usuário SIP fazer e receber chamadas. Veja mais detalhes no link `https://www.voip-info.org/asterisk-sip-type/.  <https://www.voip-info.org/asterisk-sip-type/.>`_.




.. _sip-allowtransfer:

Allowtransfer
-------------

| Permite a esta conta VoIP transferir chamadas. O código de transferência é \*2 mais o ramal. O Asterisk precisa ter atxfer => \*2 configurado no features.conf.




.. _sip-ringfalse:

Toque falso
-----------

| Ativa o toque falso. Acrescenta rR ao comando "Dial".




.. _sip-calllimit:

Limite de chamadas
------------------

| Máximo de chamadas simultâneas permitidas para este usuário SIP.




.. _sip-mohsuggest:

MOH
---

| Música de espera deste usuário SIP.




.. _sip-url-events:

URL de notificação de eventos
-----------------------------

| .




.. _sip-addparameter:

Addparameter
------------

| Os parâmetros definidos aqui substituem os parâmetros padrão do sistema e também os dos troncos, se houver.




.. _sip-amd:

AMD
---

| .




.. _sip-type-forward:

Tipo de desvio
--------------

| Tipo de destino do desvio. O desvio não funciona em filas.




.. _sip-id-ivr:

URA
---

| URA que recebe a chamada se este usuário SIP não atender.




.. _sip-id-queue:

Fila
----

| Fila que recebe a chamada se este usuário SIP não atender.




.. _sip-id-sip:

Usuário SIP
-----------

| Usuário SIP que recebe a chamada se este usuário SIP não atender.




.. _sip-extension:

Destino
-------

| Clique para mais detalhes.
| Há 3 opções, conforme o tipo selecionado: grupo, número ou personalizado.
|
| \* Grupo: o nome do grupo informado aqui precisa ser exatamente o mesmo grupo dos usuários SIP que devem receber as chamadas; todos os usuários SIP do grupo são chamados.
| \* Personalizado: executa qualquer opção válida do comando DIAL do Asterisk, por exemplo: SIP/contaSIP,45,tTr
| \* Número: pode ser um fixo ou um celular, no formato 55 + DDD.




.. _sip-dial-timeout:

Tempo de discagem
-----------------

| Tempo em segundos esperando a chamada ser atendida. Depois desse tempo, executa o desvio, se estiver configurado.




.. _sip-voicemail:

Ativar correio de voz
---------------------

| Ativa o correio de voz. É preciso configurar o SMTP no Linux para receber o e-mail com a mensagem. Veja mais detalhes no link `https://www.magnusbilling.org/br/blog-br/9-novidades/25-configurar-ssmtp-para-enviar-voicemail-no-asterisk.html.  <https://www.magnusbilling.org/br/blog-br/9-novidades/25-configurar-ssmtp-para-enviar-voicemail-no-asterisk.html.>`_.




.. _sip-voicemail-email:

E-mail
------

| E-mail para onde é enviada a mensagem do correio de voz.




.. _sip-voicemail-password:

Senha
-----

| Senha do correio de voz. É possível entrar no correio de voz discando \*111.




.. _sip-sip-config:

Parâmetros
----------

| Parâmetros SIP adicionais gravados para esta conta. Use só opções SIP válidas do Asterisk.




.. _sip-sipshowpeer:

Peer
----

| sip show peer




.. _sip-forwardtype:

Tipo de desvio
--------------

| Tipo de desvio aplicado quando este usuário SIP não atende ou está indisponível.



