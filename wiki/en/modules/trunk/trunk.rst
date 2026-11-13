
.. _trunk-id-provider:

Provedor
--------

| Provedor ao qual o tronco pertence.




.. _trunk-trunkcode:

Nome
----

| Nome do tronco; precisa ser único.




.. _trunk-user:

Usuário
-------

| Usado só se a autenticação for por usuário e senha.




.. _trunk-secret:

Senha
-----

| Usada só se a autenticação for por usuário e senha.




.. _trunk-host:

Host
----

| IP ou domínio do tronco.




.. _trunk-trunkprefix:

Adicionar prefixo
-----------------

| Acrescenta um prefixo ao número enviado ao tronco.




.. _trunk-removeprefix:

Remover prefixo
---------------

| Remove um prefixo do número enviado ao tronco.




.. _trunk-allow:

Codec
-----

| Selecione os codecs permitidos neste tronco.




.. _trunk-providertech:

Tecnologia do provedor
----------------------

| É preciso instalar o driver adequado para usar placas como DGV ou extra Dongle.




.. _trunk-status:

Status
------

| Se o tronco estiver inativo, o MagnusBilling manda a chamada para o tronco reserva.




.. _trunk-allow-error:

Ir para o reserva se 404
------------------------

| Manda a chamada para o próximo tronco se receber o erro 404.




.. _trunk-register:

Registrar tronco
----------------

| Ative só se o tronco autenticar por usuário e senha.




.. _trunk-register-string:

String de registro
------------------

| <usuario>:<senha>@<host>/contato.
| "usuario" é o ID do usuário neste servidor SIP (ex.: 2345).
| "senha" é a senha do usuário.
| "host" é o domínio ou o nome do servidor SIP.
| "porta" é a porta do host para onde o pedido de registro é enviado. O padrão é 5060.
| "contato" é o ramal de contato do Asterisk. Ex.: 1234 vai no cabeçalho Contact da mensagem SIP REGISTER. O servidor SIP remoto usa esse ramal quando precisa mandar uma chamada ao Asterisk.
|




.. _trunk-cnl:

Ativar CNL
----------

| Ativa a consulta de CNL neste tronco para aplicar as informações de numeração e roteamento brasileiras.




.. _trunk-fromuser:

Fromuser
--------

| Alguns provedores exigem este valor para autenticar, principalmente quando o tronco autentica por usuário e senha. Deixe em branco para enviar o CallerID do usuário SIP no cabeçalho From.




.. _trunk-fromdomain:

Fromdomain
----------

| Domínio usado no cabeçalho From das mensagens SIP quando o MagnusBilling age como cliente SIP (UAC).




.. _trunk-block-cid:

Bloquear CID por REGEX
----------------------

| Expressão regular usada para bloquear chamadas pelo CallerID antes de mandá-las por este tronco.




.. _trunk-context:

Contexto
--------

| Só altere se souber o que está fazendo.




.. _trunk-dtmfmode:

Dtmfmode
--------

| Modo DTMF usado por este tronco. Veja mais detalhes no link `https://www.voip-info.org/asterisk-dtmf/.  <https://www.voip-info.org/asterisk-dtmf/.>`_.




.. _trunk-insecure:

Insecure
--------

| Opção insecure do Asterisk usada neste tronco. Veja mais detalhes no link `https://www.voip-info.org/asterisk-sip-insecure/.  <https://www.voip-info.org/asterisk-sip-insecure/.>`_.




.. _trunk-maxuse:

Uso máximo
----------

| Máximo de chamadas simultâneas neste tronco.




.. _trunk-nat:

NAT
---

| Configuração de NAT usada por este tronco. Veja mais detalhes no link `https://www.voip-info.org/asterisk-sip-nat/.  <https://www.voip-info.org/asterisk-sip-nat/.>`_.




.. _trunk-directmedia:

Directmedia
-----------

| Se ativado, o Asterisk tenta mandar a mídia RTP direto entre o cliente e o provedor. O tronco também precisa aceitar mídia direta. Veja mais detalhes no link `https://www.voip-info.org/asterisk-sip-canreinvite/.  <https://www.voip-info.org/asterisk-sip-canreinvite/.>`_.




.. _trunk-qualify:

Qualify
-------

| Envia pacotes SIP OPTIONS para conferir se o tronco está online.
| Sintaxe:
|
| qualify = xxx \| no \| yes
|
| XXX é o número de milissegundos usado como tempo limite. Se o valor for "yes", o Asterisk usa o tempo configurado no sip.conf. O padrão comum é 2 segundos.
|
| Com o qualify ativado, o Asterisk envia pacotes OPTIONS regularmente para conferir se o tronco continua online.
| Se o tronco não responder no tempo configurado, o Asterisk o considera offline para as próximas chamadas.
|
| Esse status pode ser conferido com o comando "sip show peer XXXX". O Asterisk só mostra o status do qualify quando o peer tem qualify ativado.




.. _trunk-type:

Tipo
----

| O tipo padrão é "friend", que permite ao tronco fazer e receber chamadas. Veja mais detalhes no link `https://www.voip-info.org/asterisk-sip-type/.  <https://www.voip-info.org/asterisk-sip-type/.>`_.




.. _trunk-disallow:

Disallow
--------

| Codecs desativados neste tronco. Use "all" para desativar todos e depois ativar só os codecs selecionados no campo Allow.




.. _trunk-sendrpid:

Sendrpid
--------

| Define se o MagnusBilling envia o cabeçalho SIP Remote-Party-ID.
| O padrão é "no".
|
| Este campo é muito usado por provedores VoIP de atacado para informar a identidade de quem liga, independentemente das configurações de privacidade (cabeçalho SIP From).




.. _trunk-addparameter:

Addparameter
------------

| Estes parâmetros são acrescentados ao comando AGI final (comando Dial), definido no menu de ajustes.
| Por padrão, o comando DIAL é:
| ,60,L(%timeout%:61000:30000)
|
| Se você quiser acrescentar uma MACRO ao tronco, coloque aqui o parâmetro M(nome_da_macro) e crie a MACRO nas extensions do Asterisk.
|




.. _trunk-port:

Porta
-----

| Para usar uma porta diferente da 5060, é preciso liberar a porta no IPTABLES.




.. _trunk-link-sms:

Link do SMS
-----------

| URL para envio de SMS. Troque o número por %number% e o texto por %text%. EXEMPLO: se a sua URL de SMS for http://trunkWebSite.com/sendsms.php?user=magnus&pass=billing&number=XXXXXX&sms_text=SSSSSSSSSSS, troque XXXXXX por %number% e SSSSSSSSSSS por %text%.




.. _trunk-sms-res:

Resultado esperado do SMS
-------------------------

| Deixe em branco para não esperar a resposta do provedor. Ou escreva o texto que precisa constar na resposta do provedor para o SMS ser considerado ENVIADO.




.. _trunk-sip-config:

Parâmetros
----------

| Formato válido do sip.conf do Asterisk, uma opção por linha.
| Exemplo: se precisar colocar o parâmetro useragent, coloque neste campo:
|
| useragent=my agent
|
| .




.. _trunk-cid-add:

Adicionar prefixo ao CID
------------------------

| Prefixo acrescentado ao CallerID antes de a chamada ser enviada a este tronco.




.. _trunk-cid-remove:

Remover prefixo do CID
----------------------

| Prefixo removido do CallerID antes de a chamada ser enviada a este tronco.



