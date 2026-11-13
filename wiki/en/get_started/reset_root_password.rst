***************************************
Recuperar a senha do MagnusBilling
***************************************

Recuperar a senha do root do MagnusBilling. Para recuperar ou trocar a senha do root no MagnusBilling, basicamente fazemos algumas alterações direto no banco MySQL / MariaDB do MagnusBilling. Você pode fazer isso pelo console, como neste tutorial, ou pelo phpMyAdmin (nesse caso, use os mesmos comandos MySQL mostrados nos últimos passos deste tutorial).


**1.** ENTRE COMO ROOT NO SSH DO SERVIDOR MAGNUSBILLING.

Com um cliente SSH, por exemplo o Putty, entramos no terminal (shell) do servidor MagnusBilling. Informe o IP ou o domínio do servidor e depois entre com o usuário root e a senha dele. Se você usa outro usuário, entre com ele e passe para root com o comando sudo.

.. image:: ../img/putty.png
        :scale: 80%

.. image:: ../img/entrar-como_root-no-terminal-SSH-root-do-Magnus-Billing.png
        :scale: 80%


**2.** ENTRE COMO ROOT NO BANCO MYSQL.

Agora rode o comando:

::

  mysql –u root –p mbilling


Por padrão, o script de instalação do MagnusBilling guarda a senha de root do MySQL no arquivo /root/passwordMysql.log, então você pode ver essa senha com o comando

::

  cat /root/passwordMysql.log

.. image:: ../img/access-mysql-magnusbilling.png
        :scale: 80%



**3.** ALTERE A SENHA DIRETO NO BANCO.

Depois de digitar a senha, aparece o monitor do MySQL, onde colocamos os comandos para trocar a senha do painel de administração do MagnusBilling e recuperar o acesso. Se você tiver o phpMyAdmin no servidor, também pode rodar estes comandos por ele.

O MagnusBilling usa o algoritmo SHA1 para criptografar a senha dos usuários administradores.

Como não sabemos a senha atual (ela está criptografada), definimos uma senha nova assim.
Neste exemplo, voltamos para a senha padrão de uma instalação nova do MagnusBilling, que é magnus. Mas você pode usar a senha que quiser, com números, letras e símbolos.


::

  UPDATE pkg_user SET password = SHA1("magnus") WHERE username = "root";


Depois de rodar este comando, a senha de administrador do MagnusBilling está redefinida e você pode entrar no painel normalmente. Troque essa senha logo em seguida.
