
.. _campaign-id-user:

Usuário
-------

| Usuário dono da campanha.




.. _campaign-id-plan:

Plano
-----

| Plano usado para tarifar esta campanha.




.. _campaign-name:

Nome
----

| Nome da campanha.




.. _campaign-callerid:

CallerID
--------

| Número de identificação (CallerID) enviado nas chamadas desta campanha.




.. _campaign-status:

Status
------

| Status da campanha.




.. _campaign-startingdate:

Data de início
--------------

| A campanha começa a partir desta data.




.. _campaign-expirationdate:

Data de término
---------------

| A campanha para nesta data.




.. _campaign-type:

Tipo
----

| Escolha Voz, SMS ou WhatsApp.
| No WhatsApp, o MagnusBilling usa a WhatsApp Business Cloud API oficial da Meta e envia um modelo aprovado configurado na aba Mensagens. O MagnusBilling só faz a integração; quem processa e entrega a mensagem é a Meta. O dono da conta é responsável pelo consentimento dos destinatários, pelo conteúdo, pelos modelos, pelas cobranças e pelo cumprimento de todas as leis aplicáveis e das políticas da Meta/WhatsApp.




.. _campaign-whatsapp-template-name:

Nome do modelo do WhatsApp
--------------------------

| Nome exato de um modelo aprovado no WhatsApp Manager. A integração atual envia modelos sem componentes variáveis; use um modelo que não exija parâmetros.




.. _campaign-whatsapp-template-language:

Idioma do modelo do WhatsApp
----------------------------

| Código exato do idioma aprovado para o modelo do WhatsApp, por exemplo en_US ou pt_BR. O nome e o idioma precisam ser iguais aos do modelo no WhatsApp Manager.




.. _campaign-audio:

Áudio
-----

| Disponível para chamadas em massa. O áudio precisa ser compatível com o Asterisk. O formato recomendado é GSM ou WAV (8 kHz mono).




.. _campaign-audio-2:

Áudio 2
-------

| Se você usar TTS, o nome é falado entre o Áudio e o Áudio 2.




.. _campaign-restrict-phone:

Restringir números
------------------

| Com esta opção ativada, o MagnusBilling confere se o número de destino está cadastrado no menu Números restritos; se estiver, muda o status do número para bloqueado e não faz a chamada.




.. _campaign-auto-reprocess:

Reprocessar automaticamente
---------------------------

| Se não houver números ativos na agenda desta campanha, reativa todos os números pendentes.




.. _campaign-id-phonebook:

Agendas
-------

| Selecione uma ou mais agendas a usar.




.. _campaign-digit-authorize:

Número para encaminhar
----------------------

| Quer encaminhar a chamada depois do áudio? Ex.: se a pessoa digitar 1, vai para o usuário SIP XXXX. Coloque Número para encaminhar = 1, Tipo de encaminhamento = SIP e selecione o usuário SIP de destino. Use -1 para desativar.




.. _campaign-type-0:

Tipo de encaminhamento
----------------------

| Escolha o tipo de redirecionamento. A chamada é enviada ao destino escolhido.




.. _campaign-id-ivr-0:

URA
---

| Escolha uma URA para onde mandar a chamada. A URA precisa pertencer ao dono da campanha.




.. _campaign-id-queue-0:

Fila
----

| Escolha uma fila para onde mandar a chamada. A fila precisa pertencer ao dono da campanha.




.. _campaign-id-sip-0:

Usuário SIP
-----------

| Escolha um usuário SIP para onde mandar a chamada. O usuário SIP precisa pertencer ao dono da campanha.




.. _campaign-extension-0:

Destino
-------

| Clique para mais detalhes.
| Há duas opções.
|     * Grupo: informe o nome do grupo exatamente como aparece nos usuários SIP que devem receber as chamadas.
|     * Personalizado: executa qualquer opção válida pela aplicação Dial do Asterisk, por exemplo ``PJSIP/endpoint,45,tTr``.




.. _campaign-record-call:

Gravar chamada
--------------

| Grava as chamadas da campanha. Só são gravadas se a chamada for transferida.




.. _campaign-daily-start-time:

Hora de início diária
---------------------

| Hora em que a campanha começa a enviar.




.. _campaign-daily-stop-time:

Hora de término diária
----------------------

| Hora em que a campanha para de enviar.




.. _campaign-monday:

Segunda-feira
-------------

| Com esta opção ativada, o sistema faz chamadas às segundas-feiras.




.. _campaign-tuesday:

Terça-feira
-----------

| Com esta opção ativada, o sistema faz chamadas às terças-feiras.




.. _campaign-wednesday:

Quarta-feira
------------

| Com esta opção ativada, o sistema faz chamadas às quartas-feiras.




.. _campaign-thursday:

Quinta-feira
------------

| Com esta opção ativada, o sistema faz chamadas às quintas-feiras.




.. _campaign-friday:

Sexta-feira
-----------

| Com esta opção ativada, o sistema faz chamadas às sextas-feiras.




.. _campaign-saturday:

Sábado
------

| Com esta opção ativada, o sistema faz chamadas aos sábados.




.. _campaign-sunday:

Domingo
-------

| Com esta opção ativada, o sistema faz chamadas aos domingos.




.. _campaign-frequency:

Limite de chamadas
------------------

| Quantos números serão processados por minuto?
| O valor é dividido por 60 segundos e as chamadas são enviadas a cada minuto ao mesmo tempo.




.. _campaign-max-frequency:

Limite máximo de chamadas
-------------------------

| Valor máximo que o cliente pode configurar. Se for 50, o usuário pode usar qualquer valor de 50 para baixo.




.. _campaign-nb-callmade:

Duração do áudio
----------------

| Usado para controlar o máximo de chamadas completadas.




.. _campaign-enable-max-call:

Ativar máximo de chamadas completadas
-------------------------------------

| Se ativado, o MagnusBilling confere quantas chamadas já foram feitas com duração maior que a dos áudios. Se a quantidade for igual ou maior que o valor do campo, a campanha é desativada.




.. _campaign-secondusedreal:

Máximo de chamadas completadas
------------------------------

| Quantidade máxima de chamadas completadas. É preciso ativar o campo acima para usar.




.. _campaign-description:

Descrição ou texto do SMS
-------------------------

| Este campo tem usos diferentes conforme a campanha seja de voz ou de SMS.
| Usos:
|     * Voz: o campo é só uma descrição da campanha.
|     * SMS: o texto daqui é enviado aos números. Você pode usar a variável %name% onde quiser o nome do cliente. Exemplo:
|     Olá %name%




.. _campaign-tts-audio:

Áudio 1 TTS
-----------

| Com esta configuração, o sistema gera o áudio 1 da campanha por TTS.
| Para funcionar, é preciso configurar a URL de TTS em Configurações, Configuração, TTS URL.




.. _campaign-tts-audio2:

Áudio 2 TTS
-----------

| Mesma configuração do campo anterior, para o áudio 2. Entre o áudio 1 e o 2, o TTS fala o nome importado com o número.



