Migração a partir do MagnusBilling 7
====================================

Finalidade e caminho suportado
------------------------------

Este documento descreve a migração suportada do MagnusBilling 7 para o
MagnusBilling 8. Vale para instalações do MagnusBilling 7 no Debian e para
instalações legadas no CentOS 7.

É uma migração lado a lado para um servidor novo. Não é uma atualização no mesmo
servidor.

As principais mudanças de plataforma são:

* o Asterisk 13 é substituído pelo Asterisk 20;
* o ``chan_sip`` é substituído pelo PJSIP;
* o MagnusBilling 8 é instalado num servidor Debian novo;
* os clientes com o complemento privado ``app_mbilling`` precisam pedir à
  MagnusSolution uma reinstalação compatível com o MB8.

.. note::

   Nos servidores Comunic, a importação do banco e a migração seletiva são feitas
   pelos scripts ``comunic/importar-banco.sh`` e ``comunic/migrar-dados.sh``, que
   seguem este procedimento e acrescentam backup, conferências e as customizações
   (veja ``comunic/README.md`` e ``comunic/docs/ROTEIRO-MAGALU.md``).

.. warning::

   Nunca rode o instalador do MagnusBilling 8 sobre o servidor de produção do
   MagnusBilling 7. Nunca copie para o servidor novo os binários e módulos antigos
   do Asterisk, o diretório ``/etc/asterisk`` inteiro ou a aplicação web do
   MagnusBilling 7.

Visão geral da migração
-----------------------

#. Levante e atualize a instalação do MagnusBilling 7.
#. Instale e confira o MagnusBilling 8 num servidor Debian novo.
#. Ensaie a migração completa antes da janela de manutenção.
#. Congele as gravações no MagnusBilling 7 e faça um dump completo final do banco.
#. Restaure o dump no MagnusBilling 8 e rode o ``UpdateMysql``.
#. Revise cada tronco e cada endpoint depois da conversão para PJSIP.
#. Combine a reinstalação do ``app_mbilling`` privado, se ele for contratado.
#. Rode os testes de aceitação e passe o tráfego de produção.
#. Mantenha o servidor antigo parado e intacto durante o período de retorno.

Antes da migração
-----------------

Anote estas informações antes de mexer em qualquer um dos servidores:

* versão do MagnusBilling e do sistema operacional;
* IPs públicos e privados, registros DNS, NAT e regras de firewall;
* troncos SIP, registros nos provedores, autenticação por IP, codecs e DTMF;
* DIDs, filas, URAs, campanhas e dialplan personalizado;
* gravações, música de espera, áudios, certificados e scripts próprios;
* tarefas do cron e integrações externas;
* se o ``app_mbilling`` está instalado;
* quantidades atuais de registros, saldos importantes e custos de chamadas de
  exemplo.

Diminua o TTL dos registros DNS relevantes 24 a 48 horas antes da virada. Defina os
critérios de aceitação, a janela de manutenção e o prazo para decidir voltar.

Prepare o servidor novo
-----------------------

Instale o MagnusBilling 8 num servidor Debian mínimo novo:

::

   curl -O https://raw.githubusercontent.com/magnussolution/magnusbilling/source/script/install.sh
   bash install.sh

Para uma migração em etapas, o repositório também traz o
``script/updateV7_to_V8.sh``. Ele pode ser rodado num servidor Debian limpo antes de
instalar a aplicação web. O script compila o Asterisk 20 com PJSIP, desativa o
``chan_sip`` na configuração base gerada, cria os arquivos de include do MagnusBilling
e deixa o arquivo de conexão com o banco para o instalador do MagnusBilling 8 criar:

::

   curl -O https://raw.githubusercontent.com/magnussolution/magnusbilling/source/script/updateV7_to_V8.sh
   chmod 750 updateV7_to_V8.sh
   sudo ./updateV7_to_V8.sh --configure-firewall

Se o ``/etc/asterisk`` já tiver arquivos, o script arquiva automaticamente o
diretório antigo em ``/root/asterisk-config-before-mb8-*.tar.gz`` e cria uma
configuração PJSIP limpa; ele não importa o ``sip.conf`` antigo nem os módulos do
``chan_sip``. A opção antiga ``--allow-existing`` continua aceita por compatibilidade,
mas não é mais necessária.
Na instalação limpa normal, rodar o ``script/install.sh`` continua sendo o caminho
mais curto, porque instala a aplicação web e o Asterisk juntos.

Confira a instalação limpa antes de importar qualquer dado da versão 7:

* o painel web abre e o administrador consegue entrar;
* o MariaDB e o Apache estão rodando;
* ``asterisk -rx "core show version"`` informa o Asterisk 20;
* o PJSIP carrega sem erros de configuração;
* as tarefas agendadas do MagnusBilling estão instaladas;
* o firewall libera só os serviços necessários.

Mantenha a configuração do banco criada pelo MagnusBilling 8 em
``/etc/asterisk/res_config_mysql.conf``. O usuário da aplicação no MariaDB e as
permissões dele continuam no servidor novo quando o banco ``mbilling`` limpo é
substituído.

Faça um backup completo da versão 7
-----------------------------------

O menu Backup comum e o comando ``Backup`` deixam de fora os dados de algumas tabelas
grandes de histórico. Eles servem para a recuperação de rotina, mas não podem ser o
único backup usado numa migração completa.

Leia a conexão com o banco em ``/etc/asterisk/res_config_mysql.conf`` no servidor da
versão 7 e faça um dump lógico completo, com triggers:

::

   mysqldump \
     --host=DATABASE_HOST \
     --user=DATABASE_USER \
     --password \
     --single-transaction \
     --quick \
     --triggers \
     --hex-blob \
     --default-character-set=utf8 \
     mbilling > /root/mbilling7-full.sql

Comprima o dump e gere um checksum:

::

   gzip /root/mbilling7-full.sql
   sha256sum /root/mbilling7-full.sql.gz \
     > /root/mbilling7-full.sql.gz.sha256

O repositório também traz o ``doc/migrate7_8.sh`` para criar e restaurar um dump de
migração validado. Rode ``doc/migrate7_8.sh help`` antes de usá-lo.

Copie à parte as gravações, áudios, músicas de espera, certificados e outros
arquivos dos clientes. Arquive o ``/etc/asterisk`` só para consulta. Não restaure o
diretório antigo inteiro no servidor novo.

Ensaio
------

Faça pelo menos um ensaio com um backup recente da produção. Anote o tempo gasto na
transferência, na restauração, na migração do banco, na revisão do PJSIP e nos
testes de aceitação.

O ensaio precisa ter o mesmo tamanho de banco e os mesmos módulos opcionais usados na
produção. Resolva todos os erros de SQL e de PJSIP antes de agendar a virada final.

Backup final e congelamento das gravações
-----------------------------------------

No começo da janela de manutenção, pare tudo o que grava no servidor antigo
(chamadas e web). Mantenha o MariaDB rodando o tempo suficiente para fazer o dump
final.

No Debian, os serviços normalmente são:

::

   systemctl stop asterisk apache2 cron

No CentOS 7, normalmente são:

::

   systemctl stop asterisk httpd crond

Faça um dump completo novo depois de parar os serviços, confira o checksum e
transfira para o servidor novo. Não deixe os dois servidores processarem tráfego de
produção ao mesmo tempo.

Restaure e migre o banco
------------------------

No servidor novo, pare tudo o que grava:

::

   systemctl stop asterisk apache2 cron

Guarde um dump do banco limpo do MagnusBilling 8 e depois o substitua:

::

   mariadb-dump --protocol=socket --triggers mbilling \
     | gzip > /root/mbilling8-clean-before-migration.sql.gz

   mariadb --protocol=socket -e \
     "DROP DATABASE IF EXISTS mbilling;
      CREATE DATABASE mbilling CHARACTER SET utf8 COLLATE utf8_general_ci;"

   gunzip -c /root/mbilling7-full.sql.gz \
     | mariadb --protocol=socket mbilling

Rode o migrador de banco do MagnusBilling:

::

   php /var/www/html/mbilling/cron.php UpdateMysql

O comando precisa terminar sem erro de SQL e informar uma versão do MagnusBilling 8.
Não inicie os serviços de produção se o comando de migração falhar.

Conversão para PJSIP
--------------------

O migrador de banco muda os valores de tecnologia compatíveis dos troncos de ``sip``
para ``pjsip``. Ele também converte os tokens de tecnologia legados em
``pkg_did_destination.destination`` e ``pkg_campaign.forward_number``. O campo de
texto livre legado ``pkg_sip.sip_config`` só é convertido nos tokens de discagem
``SIP/`` explícitos; esquemas de URI SIP, nomes de usuário e textos sem relação não
são renomeados. ``pkg_sip`` continua sendo o nome da tabela no MagnusBilling 8; não
existe coluna de tecnologia em ``pkg_sip``.

O migrador não consegue traduzir todas as opções personalizadas do ``chan_sip`` nem
as mudanças manuais do ``sip.conf``.

Revise manualmente, em cada tronco e endpoint, a autenticação, o registro, a
identificação por IP, o NAT, os codecs, o ``fromuser``, o ``fromdomain``, o DTMF, os
cabeçalhos, o qualify e os limites de contatos.

Use a CLI do Asterisk para inspecionar a configuração convertida:

::

   asterisk -rx "pjsip show endpoints"
   asterisk -rx "pjsip show registrations"
   asterisk -rx "pjsip show contacts"

Aparelhos e provedores podem precisar de configurações próprias do PJSIP mesmo
continuando na porta UDP 5060.

Complemento privado app_mbilling
--------------------------------

O ``app_mbilling`` é um complemento comercial privado e não está no repositório
público do MagnusBilling 8. Os clientes que contrataram o complemento precisam falar
com a MagnusSolution antes da migração e pedir o pacote compatível com MB8/Asterisk 20
e o serviço de instalação.

Não copie o complemento antigo da versão 7 para o servidor novo. O fornecedor precisa
fazer a reinstalação e confirmar o escopo de suporte contratado. Este guia não
publica código-fonte, detalhes de implementação nem instruções privadas de
distribuição.

Testes de aceitação
-------------------

Faça todos os testes que se aplicam antes de passar o tráfego de produção:

* login do administrador e versão da aplicação;
* quantidades de clientes, planos, tarifas, troncos, DIDs e saldos;
* registro dos endpoints PJSIP e registro nos provedores;
* chamadas recebidas e feitas;
* preços de venda e de compra esperados nas chamadas de teste;
* criação de CDR e processamento em segundo plano;
* CallerID, DTMF, áudio nos dois sentidos e desligamento;
* comportamento de URA, fila, campanha, gravação e callback;
* tarefas do cron, backups, e-mail, API e integrações externas;
* comportamento do ``app_mbilling``, se estiver instalado.

Virada
------

#. Aponte as rotas dos provedores, as regras de IP público/NAT e os registros DNS para
   o servidor novo.
#. Inicie o MariaDB, o Apache, o cron e o Asterisk no servidor novo.
#. Repita os testes críticos de entrada, saída e tarifação com as rotas de produção.
#. Acompanhe os logs do Asterisk, do MariaDB, do Apache e do MagnusBilling.
#. Mantenha o servidor antigo parado, isolado e sem mudanças.

Retorno
-------

Se um teste de aceitação crítico falhar:

#. Pare o Asterisk, o Apache e o cron no servidor novo.
#. Devolva as rotas dos provedores, o NAT e o DNS para o servidor antigo.
#. Inicie os serviços antigos.
#. Registre a falha e corrija antes de uma nova tentativa de migração.

Não importe de volta no MagnusBilling 7 um banco que já recebeu gravações do
MagnusBilling 8. A migração não é reversível. O retorno depende do servidor e do
banco da versão 7 congelados.
