Solução de problemas: erros ao salvar
=====================================

Às vezes, ao criar ou editar registros no MagnusBilling, clicar em **Salvar** não
conclui a operação. Isso pode acontecer em qualquer módulo, como Usuários, Tarifas,
Troncos, DIDs, Alarmes, Provedores, Campanhas e outros.

Antes de investigar mais, confirme sempre que a instalação do MagnusBilling está na
versão mais recente disponível.

Atualize o MagnusBilling primeiro
---------------------------------

Muitos problemas são corrigidos nas versões novas. Antes de abrir um chamado de
suporte, atualize o MagnusBilling para a versão mais recente e teste de novo.

Se o problema continuar depois de atualizar, siga os passos abaixo.

Abra as ferramentas de desenvolvedor do navegador
-------------------------------------------------

A forma mais eficaz de identificar problemas ao salvar é inspecionar as ferramentas
de desenvolvedor do navegador.

Google Chrome
~~~~~~~~~~~~~

Pressione:

.. code-block:: text

   F12

ou

.. code-block:: text

   Ctrl+Shift+I

Microsoft Edge
~~~~~~~~~~~~~~

Pressione:

.. code-block:: text

   F12

ou

.. code-block:: text

   Ctrl+Shift+I

Mozilla Firefox
~~~~~~~~~~~~~~~

Pressione:

.. code-block:: text

   F12

ou

.. code-block:: text

   Ctrl+Shift+I

Safari
~~~~~~

Ative o menu Desenvolvedor e pressione:

.. code-block:: text

   Option+Command+I

Analise a aba Rede (Network)
----------------------------

1. Abra a aba **Network** (Rede).
2. Deixe as ferramentas de desenvolvedor abertas.
3. Clique em **Salvar** no MagnusBilling.
4. Localize a requisição gerada pela ação.

Confira:

* o código de status HTTP;
* a URL da requisição;
* os parâmetros da requisição;
* o corpo da resposta.

Códigos de status HTTP comuns
-----------------------------

+--------+--------------------------------------+
| Código | Descrição                            |
+========+======================================+
| 200    | Requisição processada com sucesso    |
+--------+--------------------------------------+
| 400    | Dados inválidos ou faltando          |
+--------+--------------------------------------+
| 401    | Problema de autenticação             |
+--------+--------------------------------------+
| 403    | Permissão negada                     |
+--------+--------------------------------------+
| 404    | Recurso não encontrado               |
+--------+--------------------------------------+
| 500    | Erro interno do servidor             |
+--------+--------------------------------------+

Analise a aba Console
---------------------

Abra a aba **Console** e confira se aparece algum erro de JavaScript ao clicar em
Salvar.

Exemplos:

* Uncaught TypeError
* SyntaxError
* Falha na requisição AJAX
* Erros de componentes ExtJS

Confira os logs do servidor
---------------------------

Se a requisição devolver HTTP 500, confira os logs do servidor web.

Apache:

.. code-block:: bash

   tail -f /var/log/apache2/error.log

CentOS/RHEL:

.. code-block:: bash

   tail -f /var/log/httpd/error_log

Reúna as informações para o suporte
-----------------------------------

Ao abrir um pedido de suporte, envie:

* captura de tela da aba Network;
* captura de tela da aba Console;
* o código de status HTTP;
* a resposta completa do servidor;
* a versão do MagnusBilling;
* o nome e a versão do navegador.

Essas informações ajudam a identificar se o problema está na validação do frontend,
nas permissões, em erros do servidor, em restrições do banco ou em customizações.

Veja também
-----------

* Atualizar o MagnusBilling
* Entendendo os erros HTTP 500
* Como reunir logs para o suporte