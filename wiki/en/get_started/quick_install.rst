Instalação
==========

O MagnusBilling 8 exige um servidor com instalação mínima do Debian. Use um servidor
dedicado ou uma máquina virtual e faça backup antes de reinstalar ou atualizar um
sistema existente.

Rodar o instalador
------------------

Conecte-se ao servidor por SSH como ``root`` e então baixe e rode o script de
instalação:

::

   wget https://raw.githubusercontent.com/magnussolution/magnusbilling/source/script/install.sh
   bash install.sh

O instalador prepara o MagnusBilling e suas principais dependências, incluindo
Asterisk 20, PJSIP, o servidor web, PHP, o banco de dados, Fail2ban e as regras de
firewall. Siga as perguntas mostradas no terminal. O servidor pode reiniciar ao
final da instalação.

.. note::

   Para instalar com as customizações da Comunic, use ``comunic/instalar.sh`` deste
   repositório (veja ``comunic/README.md``). Ele roda o instalador oficial e depois
   aplica as customizações.

Primeiro acesso
---------------

Depois de reiniciar, abra o IP do servidor no navegador:

::

   http://IP_DO_SERVIDOR

Use as credenciais iniciais mostradas pelo instalador. Uma instalação nova padrão
usa estas credenciais no painel:

::

   Usuário: root
   Senha: magnus

.. warning::

   Troque a senha padrão do painel imediatamente. Restrinja o acesso administrativo
   e o SSH a redes confiáveis sempre que possível.

.. image:: ../img/ilogin.png
   :scale: 80%
   :alt: Tela de login do MagnusBilling

Conferir a instalação
---------------------

Antes de colocar tráfego de produção, confira se:

* o painel web abre e o administrador consegue entrar;
* o banco de dados está rodando;
* o Asterisk inicia e informa a versão 20;
* os transportes e endpoints PJSIP carregam sem erros de configuração;
* os comandos agendados do MagnusBilling estão presentes;
* o firewall do servidor libera só os serviços necessários.

A configuração de console lê a conexão com o banco em
``/etc/asterisk/res_config_mysql.conf``. Se o painel web, os comandos agendados ou
as chamadas AGI não conseguirem se conectar ao banco, confira esse arquivo antes de
mexer no código da aplicação.

Pontos de entrada importantes
-----------------------------

* ``index.php`` inicia o painel web Yii.
* ``cron.php`` roda os comandos de console Yii.
* ``resources/asterisk/mbilling.php`` cuida da execução das chamadas pelo AGI do Asterisk.
* ``protected/config/main.php`` contém a configuração da aplicação web.
* ``protected/config/cron.php`` contém a configuração de console.
* ``script/database.sql`` contém a estrutura base do banco.

Continue com :doc:`Fazendo a primeira chamada <first_call>` depois que as
conferências da instalação passarem.
