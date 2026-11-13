
.. _gAuthenticator-username:

Usuário
-------

| Usuário que quer ativar o TOKEN.




.. _gAuthenticator-googleAuthenticator-enable:

Status
------

| Depois de ativar o TOKEN para o usuário, o login só é possível com o TOKEN gerado pelo app Google Authenticator.
| Com o TOKEN ativado, no próximo login o usuário precisa escanear o QR CODE, como na imagem abaixo.

.. image:: ../../img/token.png
   :scale: 100%

| Para escanear o código é preciso instalar o app Google Authenticator, disponível nas lojas de aplicativos do iOS e do Android.
|
| É importante guardar o código manual mostrado na imagem: ele será necessário se você precisar ativar o token em outro celular.
|
|
| Com o token do Google Authenticator, só é possível entrar no painel ou desativar a função de token.




.. _gAuthenticator-code:

Código
------

| O código é necessário para desativar o TOKEN. Se você não tiver mais o código, será preciso desativar pelo banco de dados.




.. _gAuthenticator-google-authenticator-key:

Chave do Google Authenticator
-----------------------------

| Esta CHAVE é necessária para ativar o TOKEN em outro celular.
