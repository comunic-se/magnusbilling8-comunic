.. _tts:

Configuração de TTS
===================

O MagnusBilling pode gerar o áudio das campanhas a partir de texto. Esta página
descreve a integração com a API da ElevenLabs e os provedores legados por URL.

Use chamadas automáticas só para contatos que consentiram em recebê-las. Siga as
regras de privacidade, telemarketing, descadastro e telecomunicações que valem nas
jurisdições de quem envia e de quem recebe.

ElevenLabs
----------

Requisitos
~~~~~~~~~~

O servidor precisa de acesso HTTPS de saída, das extensões cURL e iconv do PHP e do
``mpg123``. A conta da ElevenLabs precisa ter uma chave de API e uma voz disponível.

Mantenha a chave de API fora da raiz web. Nunca a coloque num campo de campanha,
arquivo de código, configuração no banco, captura de tela, chamado ou log.

Configuração do servidor
~~~~~~~~~~~~~~~~~~~~~~~~

Copie ``resources/elevenlabs/elevenlabs.conf.example`` para
``/etc/asterisk/elevenlabs.conf`` e edite a cópia:

.. code-block:: ini

   api_url = "https://api.elevenlabs.io/v1/text-to-speech"
   api_key = "REPLACE_WITH_ELEVENLABS_API_KEY"
   voice_id = "REPLACE_WITH_VOICE_ID"
   model_id = "eleven_multilingual_v2"
   output_format = "mp3_44100_128"

Proteja a configuração para que só o administrador e o Asterisk possam lê-la:

.. code-block:: console

   chown root:asterisk /etc/asterisk/elevenlabs.conf
   chmod 0640 /etc/asterisk/elevenlabs.conf

O caminho padrão pode ser mudado com a variável de ambiente ``ELEVENLABS_CONFIG``.

Em **Configurações > Configuração**, coloque em **TTS URL**:

.. code-block:: text

   elevenlabs

Campos da campanha
~~~~~~~~~~~~~~~~~~

Tanto ``tts_audio`` quanto ``tts_audio2`` aceitam ``%name%``. O MagnusBilling troca
pelo nome guardado para aquele contato em **Números** antes de pedir e guardar em
cache o áudio.

Exemplo:

.. code-block:: text

   tts_audio:
   Olá %name%. Temos uma informação importante para você.

   tts_audio2:
   Para receber o link por SMS, digite 2.

Quando há duas mensagens configuradas, a segunda começa logo depois da primeira. Um
dígito digitado durante a primeira é preservado e a segunda é pulada. Quando algum
dos textos tem ``%name%``, o MagnusBilling não toca a mensagem legada só com o nome,
o que evita falar o nome duas vezes.

Para trocar o modelo e a voz configurados num único texto, use:

.. code-block:: text

   MODEL_ID|VOICE_ID|Texto a sintetizar

Processamento do áudio e cache
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

O MagnusBilling converte a resposta da ElevenLabs num arquivo WAV mono de 8 kHz e
16 bits para o Asterisk. Os arquivos ficam em cache como ``/tmp/tts_audio_<hash>.wav``.

A chave do cache inclui o provedor, a voz, o modelo, o formato de saída e o texto
personalizado. Uma trava de arquivo impede que requisições simultâneas gerem (e
cobrem) o mesmo áudio duas vezes. Entradas em Windows-1252 inválidas são convertidas
para UTF-8 antes de a requisição JSON ser enviada.

Testes e solução de problemas
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Deixe só um contato de teste ativo antes de iniciar uma campanha de teste.
Acompanhe o console do Asterisk:

.. code-block:: console

   asterisk -rvvvvv

Confira os arquivos gerados ao diagnosticar o áudio:

.. code-block:: console

   file /tmp/tts_audio_*.wav

``ElevenLabs TTS request failed``
   Confira a chave de API, o ID da voz, o modelo, a cota da conta, o DNS e o HTTPS
   de saída.

A primeira mensagem toca, mas a segunda fica muda
   Confirme que o ``tts_audio2`` está preenchido, que o ``mpg123`` está instalado e
   que o console do Asterisk não mostra ``ElevenLabs TTS error`` nem erro de conversão.

Nomes com acento falham ou não geram áudio
   Atualize o MagnusBilling para a versão com a normalização para UTF-8 e gere de
   novo o arquivo de cache afetado.

Provedores legados por URL
--------------------------

Nos provedores por URL, a configuração **TTS URL** pode ter ``$name``. O
MagnusBilling troca pelo texto codificado para URL. As credenciais e opções do
provedor precisam ser trocadas pelos valores da sua conta no provedor.

Vocalware
~~~~~~~~~

Exemplo configurado para português do Brasil:

.. code-block:: text

   https://www.vocalware.com/tts/gen.php?EID=3&LID=6&VID=1&TXT=$name&EXT=mp3&FX_TYPE=&FX_LEVEL=&ACC=YOUR_ACC&API=YOUR_API&SESSION=&HTTP_ERR=&CS=&SECRET=YOUR_SECRET

Neste exemplo, ``EID=3`` é o motor, ``LID=6`` é o português e ``VID=1`` escolhe a voz.

VoiceRSS
~~~~~~~~

Exemplo configurado para português do Brasil e saída compatível com o Asterisk:

.. code-block:: text

   http://api.voicerss.org/?key=YOUR_API&hl=pt-br&src=$name&f=8khz_16bit_mono

Google
~~~~~~

O formato legado da URL do Google é:

.. code-block:: text

   https://translate.google.com/translate_tts?ie=UTF-8&q=$name&tl=pt-BR&total=1&idx=0&textlen=5&client=tw-ob&tk=$token

Interfaces, preços, limites e termos de terceiros podem mudar. Leia a documentação
atual do provedor antes de usar qualquer URL legada em produção.

Segurança e custos
------------------

Serviços de TTS podem cobrar por requisição ou por caractere. Acompanhe o uso e a
cobrança, restrinja o acesso aos arquivos de configuração e troque qualquer
credencial compartilhada em chat, e-mail, histórico do terminal ou chamado de suporte.

Referências dos provedores:

* `Documentação da API da ElevenLabs <https://elevenlabs.io/docs/api-reference/>`_
* `Vocalware <https://www.vocalware.com/>`_
* `VoiceRSS <https://www.voicerss.org/>`_
