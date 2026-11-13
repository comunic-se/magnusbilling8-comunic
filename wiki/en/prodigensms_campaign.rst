.. _prodigensms-campaign:

Campanhas com Prodigensms
=========================

Este guia configura uma campanha de voz para enviar um modelo da Prodigensms quando
o contato chamado digita o dígito de autorização da campanha.

.. important::

   O MagnusBilling não entrega o SMS. Ele envia um pedido de modelo à Prodigensms.
   O dono da conta é responsável pelo consentimento dos destinatários, pelo
   conteúdo do modelo, pelo tratamento dos descadastros, pelas cobranças do
   provedor e pelo cumprimento de todas as regras de privacidade, telecomunicações
   e mensagens aplicáveis.

Requisitos
----------

Antes de começar, confirme que:

* o servidor tem acesso HTTPS de saída e a extensão cURL do PHP;
* a conta e o token de API da Prodigensms estão ativos;
* o modelo e o encurtador já existem no provedor;
* a URL de destino está correta; e
* o contato de teste é um celular brasileiro válido.

Mantenha as credenciais fora da raiz web. Nunca coloque o token de API numa URL de
campanha, arquivo de código, campo do banco, captura de tela, chamado ou log.

1. Configure o provedor
-----------------------

Copie ``resources/prodigensms/prodigensms.conf.example`` para
``/etc/asterisk/prodigensms.conf`` e edite a cópia:

.. code-block:: ini

   api_url = "https://prodigensms.com/api/v1/sms/send"
   api_token = "REPLACE_WITH_PRODIGENSMS_TOKEN"
   webhook_secret = "REPLACE_WITH_RANDOM_SECRET"
   shortener_id = "689"
   original_url = "https://cadastro.example.com/"

Gere um segredo aleatório para o webhook e proteja o arquivo:

.. code-block:: console

   openssl rand -hex 32
   chown root:www-data /etc/asterisk/prodigensms.conf
   chmod 0640 /etc/asterisk/prodigensms.conf

O caminho padrão pode ser mudado com a variável de ambiente ``PRODIGENSMS_CONFIG``.

2. Configure a campanha
-----------------------

#. Abra **Torpedo de voz > Campanhas**.
#. Selecione a campanha e a agenda de teste.
#. Configure o dígito de autorização, por exemplo ``2``.
#. Configure as mensagens da campanha. A configuração da ElevenLabs e o uso do
   ``%name%`` estão em :doc:`Configuração de TTS <tts>`.
#. Coloque em ``forward_number``:

   .. code-block:: text

      custom|http://127.0.0.1/mbilling/index.php/prodigensms/send?number=%number%&templateId=77&name=%name%&msg=campaign+SMS+test

#. Troque ``77`` pelo ID do modelo aprovado na conta do provedor.
#. Deixe só o contato de teste ativo e inicie a campanha.

Quando o contato digita o dígito configurado, o MagnusBilling troca ``%number%`` e
``%name%`` e chama o callback local.

3. Entenda o que é enviado ao provedor
--------------------------------------

O controller envia uma requisição JSON como esta:

.. code-block:: json

   {
     "to": "5511999999999",
     "templateId": 77,
     "shortenerId": 689,
     "originalUrl": "https://cadastro.example.com/",
     "name": "Nome do contato",
     "msg": "campaign SMS test"
   }

Os parâmetros são tratados assim:

``number``
   Vira ``to`` e é normalizado para um celular brasileiro.

``templateId``
   É obrigatório na URL da campanha e precisa ser um inteiro positivo.

``shortenerId`` e ``originalUrl``
   Usam os padrões da configuração do servidor. Valores válidos na URL do callback
   substituem esses padrões.

Outros parâmetros da query
   Todos os outros parâmetros escalares válidos são repassados à Prodigensms. Isso
   permite ``name``, ``msg`` e variáveis adicionais aceitas pelo modelo escolhido. O
   controller aceita até 30 parâmetros extras, com limites de validação nos nomes e
   nos valores.

Os parâmetros ``key``, ``number``, ``templateId`` e ``to`` são reservados e não são
repassados como variáveis extras do modelo.

4. Segurança do callback
------------------------

Use ``127.0.0.1`` quando o Asterisk e a aplicação web do MagnusBilling estiverem no
mesmo servidor. Requisições locais (loopback) não precisam da chave do webhook.

Uma requisição externa precisa usar HTTPS e incluir o segredo configurado:

.. code-block:: text

   https://SEU_HOST/mbilling/index.php/prodigensms/send?key=WEBHOOK_SECRET&number=5511999999999&templateId=77

Não exponha o callback externo se não for necessário. Proteja o servidor com as
práticas normais de firewall e de controle de acesso do MagnusBilling.

5. Teste o callback
-------------------

Sempre coloque entre aspas, no shell, uma URL que tenha ``&``:

.. code-block:: console

   curl 'http://127.0.0.1/mbilling/index.php/prodigensms/send?number=5511999999999&templateId=77&name=Test'

Para espaços e caracteres especiais, use:

.. code-block:: console

   curl --get 'http://127.0.0.1/mbilling/index.php/prodigensms/send' \
     --data-urlencode 'number=5511999999999' \
     --data-urlencode 'templateId=77' \
     --data-urlencode 'name=Contato de teste' \
     --data-urlencode 'msg=Teste de SMS da campanha'

Um callback bem-sucedido devolve:

.. code-block:: json

   {"success":true,"provider_status":200}

Se a URL não estiver entre aspas, o shell trata cada ``&`` como separador de comando
em segundo plano. O servidor recebe só o primeiro parâmetro e normalmente devolve
``invalid_template_id``.

6. Teste a campanha completa
----------------------------

#. Deixe só o contato de teste ativo.
#. Confira as mensagens, o dígito de autorização, o ID do modelo e o
   ``forward_number``.
#. Inicie a campanha e atenda a chamada.
#. Confirme que as duas mensagens tocam e digite o dígito de autorização.
#. Confirme que o SMS chega.
#. Confira se o relatório da campanha registra o encaminhamento.

Acompanhe o console do Asterisk durante o teste:

.. code-block:: console

   asterisk -rvvvvv

Problemas comuns
----------------

``invalid_template_id``
   Confira se o ``templateId`` é numérico e está presente. Coloque a URL inteira do
   cURL entre aspas.

``invalid_number``
   O endpoint aceita celulares brasileiros e os normaliza para
   ``55 + DDD + celular de 9 dígitos``.

``forbidden``
   Um callback externo não trouxe a ``key`` correta. Prefira o callback local
   (loopback) numa campanha local.

``provider_error``
   Confira o token de API, o modelo, o encurtador, o status da conta, o saldo no
   provedor, a conectividade HTTPS de saída e o log da aplicação MagnusBilling.

O dígito de autorização não envia o SMS
   Confirme que o dígito da campanha é o mesmo digitado, que a URL de encaminhamento
   começa com ``custom|``, que o número continua ativo para o teste e que o relatório
   da campanha registra o resultado do DTMF.

Segurança e manutenção
----------------------

Troque qualquer credencial compartilhada em chat, e-mail, histórico do terminal ou
chamado de suporte. Use um token de API restrito quando houver, proteja os backups
que contêm o ``/etc/asterisk`` e acompanhe o uso e a cobrança do provedor.

Referência do provedor:

* `Prodigensms <https://prodigensms.com/>`_
