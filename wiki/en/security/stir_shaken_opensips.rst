STIR/SHAKEN no proxy OpenSIPS 3.6
=================================

Este guia explica como ativar a assinatura e a verificação STIR/SHAKEN no proxy
OpenSIPS 3.6 usado pelo MagnusBilling 8.

A integração não muda o roteamento master/slave nem a escolha do dispatcher. O
cabeçalho privado enviado aos slaves do MagnusBilling continua exatamente assim::

   P-CallerID: display-name|number

Os dialplans dos slaves existentes podem continuar lendo esse cabeçalho com::

   Set(CALLERID(name)=${CUT(PJSIP_HEADER(read,P-CallerID),|,1)})
   Set(CALLERID(num)=${CUT(PJSIP_HEADER(read,P-CallerID),|,2)})

Requisitos
----------

A assinatura em produção exige este material de uma autoridade STIR/SHAKEN aprovada:

* um certificado STI X.509 válido em formato PEM;
* a chave privada correspondente em formato PEM;
* uma URL HTTPS pública e estável (``x5u``) que sirva o certificado STI; e
* uma política de atestação adequada a quem liga, depois de autenticado.

Não use certificado autoassinado em produção. Nunca publique a chave privada. O
relógio do servidor precisa estar sincronizado por NTP, porque a janela de validade
configurada para autenticação e verificação é de 60 segundos.

Publique o certificado
----------------------

Publique só o certificado num endereço HTTPS estável, por exemplo::

   https://certificates.example.com/stir/certificate.pem

A URL precisa usar um certificado TLS válido, devolver HTTP 200 e servir o
certificado STI em PEM. Teste antes da instalação::

   curl --fail --show-error --location \
     https://certificates.example.com/stir/certificate.pem

Inspecione o certificado publicado::

   curl --fail --silent \
     https://certificates.example.com/stir/certificate.pem \
     | openssl x509 -noout -subject -issuer -dates

Escolha a atestação
-------------------

Use a atestação mais forte que o processo de autenticação e de autorização do
Caller ID consiga sustentar com verdade:

``A``
   O cliente está autenticado e autorizado a usar o número apresentado.

``B``
   O cliente está autenticado, mas a autorização para aquele número específico não
   foi totalmente comprovada.

``C``
   A chamada chegou por um gateway e não é possível autenticar quem originou.

Não atribua ``A`` a todo o tráfego, a menos que o MagnusBilling ou um sistema
anterior tenha comprovado que cada assinante é dono ou controla o número
apresentado. O padrão do instalador é ``C``.

Instalação de um proxy novo
---------------------------

Valide primeiro os arquivos locais::

   openssl x509 -in /root/stir/certificate.pem \
     -noout -subject -issuer -dates
   openssl pkey -in /root/stir/private-key.pem -check -noout

Rode o instalador com o material de assinatura em variáveis de ambiente::

   sudo env \
     STIR_SHAKEN_CERT_PATH=/root/stir/certificate.pem \
     STIR_SHAKEN_KEY_PATH=/root/stir/private-key.pem \
     STIR_SHAKEN_X5U=https://certificates.example.com/stir/certificate.pem \
     STIR_SHAKEN_ATTESTATION=A \
     STIR_SHAKEN_VERIFY_REJECT=0 \
     ./script/installOpenSips-3.6.sh PUBLIC_IP MAGNUSBILLING_IP

Quando o endereço local (bind) for diferente do endereço público anunciado, passe-o
como terceiro argumento::

   sudo env \
     STIR_SHAKEN_CERT_PATH=/root/stir/certificate.pem \
     STIR_SHAKEN_KEY_PATH=/root/stir/private-key.pem \
     STIR_SHAKEN_X5U=https://certificates.example.com/stir/certificate.pem \
     STIR_SHAKEN_ATTESTATION=A \
     STIR_SHAKEN_VERIFY_REJECT=0 \
     ./script/installOpenSips-3.6.sh PUBLIC_IP MAGNUSBILLING_IP LOCAL_IP

O instalador faz o seguinte:

#. Instala os módulos STIR/SHAKEN e HTTP do OpenSIPS.
#. Cria ``/etc/opensips/stir-shaken``.
#. Instala o certificado, a chave privada e a lista de CAs confiáveis.
#. Cria a ``stir_shaken_config`` no banco ``opensips``.
#. Ativa a assinatura só depois de o MySQL carregar com sucesso o certificado e a
   chave privada.
#. Ativa a verificação em modo só de monitoramento, por padrão.

Se ``STIR_SHAKEN_CERT_PATH``, ``STIR_SHAKEN_KEY_PATH`` e ``STIR_SHAKEN_X5U`` não forem
informados, a instalação continua com a assinatura desativada.

Atualizar um proxy existente
----------------------------

Instale os módulos::

   sudo apt update
   sudo apt install -y opensips-stir-shaken-module opensips-http-modules

Implante a configuração atualizada::

   sudo cp script/opensips-3.6.cfg /etc/opensips/opensips.cfg

Se o arquivo foi copiado direto do código-fonte, troque os marcadores do instalador
``MYSQLUSER:MYSQLPASS``, ``MYIP``, ``LOCALIP`` e ``MASTERIP`` pelos valores daquele
proxy.

Crie o diretório do certificado e a lista de confiança inicial::

   sudo install -d -o opensips -g opensips -m 0755 \
     /etc/opensips/stir-shaken
   sudo cp /etc/ssl/certs/ca-certificates.crt \
     /etc/opensips/stir-shaken/ca-list.pem
   sudo chown opensips:opensips \
     /etc/opensips/stir-shaken/ca-list.pem
   sudo chmod 0640 /etc/opensips/stir-shaken/ca-list.pem

Abra o cliente do banco com ``mysql -u root -p opensips`` e crie a tabela de
configuração::

   CREATE TABLE IF NOT EXISTS stir_shaken_config (
       id TINYINT UNSIGNED NOT NULL PRIMARY KEY,
       sign_enabled TINYINT(1) NOT NULL DEFAULT 0,
       verify_enabled TINYINT(1) NOT NULL DEFAULT 1,
       verify_reject TINYINT(1) NOT NULL DEFAULT 0,
       attestation ENUM('A','B','C') NOT NULL DEFAULT 'C',
       x5u VARCHAR(1024) NOT NULL DEFAULT '',
       certificate LONGTEXT NULL,
       private_key LONGTEXT NULL,
       updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
           ON UPDATE CURRENT_TIMESTAMP
   ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

   INSERT IGNORE INTO stir_shaken_config (id) VALUES (1);

Deixe temporariamente os arquivos legíveis para o processo do MySQL::

   sudo install -o root -g mysql -m 0640 /root/stir/certificate.pem \
     /etc/opensips/stir-shaken/certificate.pem
   sudo install -o root -g mysql -m 0640 /root/stir/private-key.pem \
     /etc/opensips/stir-shaken/private-key.pem

Carregue o material sem colar nem imprimir a chave privada::

   SET @stir_cert =
       LOAD_FILE('/etc/opensips/stir-shaken/certificate.pem');
   SET @stir_key =
       LOAD_FILE('/etc/opensips/stir-shaken/private-key.pem');

   UPDATE stir_shaken_config
   SET sign_enabled =
           IF(@stir_cert IS NOT NULL AND @stir_key IS NOT NULL, 1, 0),
       verify_enabled = 1,
       verify_reject = 0,
       attestation = 'A',
       x5u = 'https://certificates.example.com/stir/certificate.pem',
       certificate = @stir_cert,
       private_key = @stir_key
   WHERE id = 1;

Restaure o dono e as permissões restritivas::

   sudo chown opensips:opensips \
     /etc/opensips/stir-shaken/certificate.pem \
     /etc/opensips/stir-shaken/private-key.pem
   sudo chmod 0640 \
     /etc/opensips/stir-shaken/certificate.pem \
     /etc/opensips/stir-shaken/private-key.pem

Confirme que o conteúdo foi carregado, sem mostrá-lo::

   SELECT id, sign_enabled, verify_enabled, verify_reject,
          attestation, x5u,
          LENGTH(certificate) AS certificate_bytes,
          LENGTH(private_key) AS private_key_bytes,
          updated_at
   FROM stir_shaken_config
   WHERE id = 1;

Política de verificação
-----------------------

A política padrão é::

   verify_enabled = 1
   verify_reject  = 0

É o modo só de monitoramento. Identidades válidas e inválidas são registradas em
log e repassadas ao MagnusBilling como metadados de verificação, mas falhas de
STIR/SHAKEN não recusam chamadas.

Depois de acompanhar a interoperabilidade com cada provedor, a recusa estrita pode
ser ativada::

   UPDATE stir_shaken_config
   SET verify_enabled = 1, verify_reject = 1
   WHERE id = 1;

Volte ao modo só de monitoramento com::

   UPDATE stir_shaken_config
   SET verify_reject = 0
   WHERE id = 1;

Desative a verificação com::

   UPDATE stir_shaken_config
   SET verify_enabled = 0
   WHERE id = 1;

Chamadas sem o cabeçalho ``Identity`` continuam normalmente. Com
``verify_reject=1``, uma chamada que traga Identity inválido, certificado
inacessível ou assinatura inválida é recusada.

Política de assinatura
----------------------

Ative a assinatura só quando todos os valores obrigatórios existirem::

   UPDATE stir_shaken_config
   SET sign_enabled = 1
   WHERE id = 1
     AND certificate IS NOT NULL
     AND private_key IS NOT NULL
     AND x5u LIKE 'https://%';

Desative a assinatura sem apagar as credenciais::

   UPDATE stir_shaken_config
   SET sign_enabled = 0
   WHERE id = 1;

Mude a atestação, quando a política de autorização justificar::

   UPDATE stir_shaken_config
   SET attestation = 'B'
   WHERE id = 1;

As chamadas novas leem esses valores do banco na hora; não é preciso reiniciar para
mudanças de política.

Autoridades certificadoras confiáveis
-------------------------------------

O verificador lê as autoridades confiáveis de::

   /etc/opensips/stir-shaken/ca-list.pem

Se a autoridade STI não estiver no pacote de CAs do sistema, acrescente a cadeia de
CA fornecida pela autoridade::

   sudo sh -c 'cat /root/stir/sti-ca-chain.pem >> \
     /etc/opensips/stir-shaken/ca-list.pem'
   sudo chown opensips:opensips \
     /etc/opensips/stir-shaken/ca-list.pem
   sudo chmod 0640 /etc/opensips/stir-shaken/ca-list.pem

Recarregue a lista de confiança::

   sudo opensips-cli -x mi stir_shaken_ca_reload

Algumas revisões do pacote usam o nome mais novo do comando MI::

   sudo opensips-cli -x mi stir_shaken:ca_reload

Valide e reinicie o OpenSIPS
----------------------------

Valide a configuração antes de reiniciar::

   sudo /sbin/opensips -C /etc/opensips/opensips.cfg

Depois reinicie e inspecione o serviço::

   sudo systemctl restart opensips
   sudo systemctl status opensips --no-pager
   sudo opensips-cli -x mi which | grep -i stir

Chamadas de teste
-----------------

Faça uma chamada de saída e inspecione o INVITE repassado com ``sudo sngrep``. Uma
chamada autenticada deve ter cabeçalhos parecidos com::

   Date: ...
   Identity: ...;info=<https://.../certificate.pem>;alg=ES256;ppt=shaken
   P-CallerID: display-name|number

A escolha do dispatcher e o master ou slave escolhido continuam iguais.

Numa chamada de entrada com ``Identity``, o proxy acrescenta um destes cabeçalhos
internos de status::

   P-STIR-Verification: passed;attest=A
   P-STIR-Verification: failed;reason=verification-failed

Inspecione os eventos de log do STIR/SHAKEN com::

   sudo grep '|STIR|' /var/log/opensips.log

As mensagens típicas de sucesso contêm::

   STIR|signed caller=... destination=... attest=A
   STIR|verified caller=... destination=... attest=A

Renovação do certificado
------------------------

Antes do vencimento:

#. Publique o certificado novo na URL ``x5u``.
#. Instale o certificado e a chave privada novos no proxy.
#. Atualize ``certificate``, ``private_key`` e, se preciso, ``x5u`` no banco.
#. Valide uma chamada de saída.
#. Mantenha o certificado antigo disponível por tempo suficiente para as chamadas em
   andamento e os caches dos verificadores remotos.

Planeje a troca antes do vencimento, porque verificadores remotos podem guardar em
cache o certificado antigo servido por uma URL ``x5u`` existente.

Solução de problemas
--------------------

Sem cabeçalho Identity nas chamadas de saída
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Confira os valores ativos::

   SELECT sign_enabled, attestation, x5u,
          LENGTH(certificate), LENGTH(private_key)
   FROM stir_shaken_config
   WHERE id = 1;

As identidades de origem e de destino também precisam ser números de telefone
válidos. O módulo não assina identidades que não consegue interpretar como números
de telefone.

``certificate-unavailable``
~~~~~~~~~~~~~~~~~~~~~~~~~~~

Teste a URL a partir do proxy::

   curl --fail --verbose \
     https://certificates.example.com/stir/certificate.pem

Confira o DNS, as regras de firewall, a validação TLS, o HTTP 200 e o tamanho da resposta.

Falha de data ou de validade
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Confira e ative a sincronização de horário::

   timedatectl status
   sudo timedatectl set-ntp true

Certificado não confiável
~~~~~~~~~~~~~~~~~~~~~~~~~

Confirme que a cadeia da autoridade STI está no ``ca-list.pem`` e recarregue a lista
de CAs. Não desative a verificação TLS do par ou do nome do host para contornar o erro.

O ``LOAD_FILE`` do MySQL devolve NULL
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Inspecione a restrição do servidor::

   SHOW VARIABLES LIKE 'secure_file_priv';

Confira também se o processo ``mysql`` consegue percorrer o diretório e ler os
arquivos temporariamente. Depois de carregar, devolva o dono para
``opensips:opensips`` e o modo ``0640``.

Lista de segurança
------------------

* Nunca publique, transmita por SIP nem registre em log a chave privada.
* Restrinja o acesso ao banco na ``stir_shaken_config``.
* Aceite só URLs ``x5u`` em HTTPS.
* Mantenha ativada a validação TLS do par e do nome do host.
* Use a atestação ``A`` só depois de autorizar o Caller ID.
* Comece com ``verify_reject=0`` e acompanhe os provedores antes de bloquear chamadas.
* Troque o certificado STI antes do vencimento.

Referências
-----------

* `Módulo STIR/SHAKEN do OpenSIPS 3.6
  <https://docs.opensips.org/manual/3-6/modules/stir_shaken/>`_
* `Módulo cliente REST do OpenSIPS 3.6
  <https://docs.opensips.org/modules/3-6/rest_client/>`_
* `RFC 8224 <https://www.rfc-editor.org/rfc/rfc8224>`_
* `RFC 8588 <https://www.rfc-editor.org/rfc/rfc8588>`_
