.. _whats-new-mbilling-8:

Novidades do MBilling 8
=======================

O MBilling 8 atualiza a base de telefonia e acrescenta um novo canal de mensagens
empresariais. As principais mudanças operacionais em relação ao MBilling 7 são o
Asterisk 20, o PJSIP como driver de canal SIP e a integração com a WhatsApp Business
Platform oficial da Meta.

Asterisk 20
-----------

As instalações novas do MBilling 8 compilam e instalam o Asterisk 20. O instalador
usa a implementação PJProject embutida e prepara os arquivos do Asterisk usados pelo
MagnusBilling.

Ao atualizar um servidor existente, trate a troca do PBX como uma migração de
infraestrutura. Faça backup do banco e do ``/etc/asterisk``, valide os dialplans e
módulos personalizados e teste chamadas recebidas, chamadas feitas, filas, URAs,
gravações, DTMF, codecs e tarifação antes de passar o tráfego de produção.

PJSIP
-----

As instalações novas usam PJSIP no lugar do driver legado ``chan_sip``. O instalador
desativa explicitamente o ``chan_sip`` e cria estes arquivos gerenciados:

* ``/etc/asterisk/pjsip_magnus.conf`` para a configuração de servidores e troncos;
* ``/etc/asterisk/pjsip_magnus_user.conf`` para os endpoints dos clientes.

Os dois são incluídos a partir do ``/etc/asterisk/pjsip.conf``. Membros de filas,
destinos de URA, ações sobre chamadas online e contas SIP usam identificadores
``PJSIP/<endpoint>`` no MBilling 8.

Não copie um ``sip.conf`` personalizado ou um peer do ``chan_sip`` sem mudanças
esperando que funcione com PJSIP. Recrie transportes, endpoints, autenticação,
address of record, identificação, NAT, codecs e opções de registro com a semântica
do PJSIP. Depois da migração, confirme o status dos endpoints pela CLI do Asterisk e
faça chamadas de teste controladas nos dois sentidos.

Mensagens pelo WhatsApp Business
--------------------------------

O MBilling 8 pode enviar modelos de mensagem aprovados a partir de uma campanha,
pela WhatsApp Business Cloud API oficial da Meta, e pode guardar as respostas
recebidas por um webhook verificado.

A integração exige um app empresarial na Meta, uma WhatsApp Business Account, um
número remetente aceito, um token de acesso de produção e um modelo aprovado sem
parâmetros. Os destinatários precisam ter dado consentimento válido (opt-in). A Meta
continua sendo o provedor das mensagens e controla a entrega, os preços, os limites,
a qualidade e a aplicação das políticas.

Veja :doc:`whatsapp_campaign` para o guia completo de configuração, campanha,
webhook, segurança, consentimento e solução de problemas.

Observação de compatibilidade
-----------------------------

Esta página descreve os padrões de uma instalação nova do MBilling 8. Servidores
existentes podem ter personalizações locais de Asterisk, rede, troncos, dialplan ou
automação. Valide essas personalizações no servidor real antes de atualizar;
instalar só o código web não migra todas as configurações do PBX.
