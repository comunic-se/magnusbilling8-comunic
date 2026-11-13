.. _config:

Configuração
============

A configuração do MagnusBilling se divide entre registros do painel, arquivos da
aplicação e arquivos do Asterisk. Identifique qual camada é dona de uma configuração
antes de alterá-la.

Configuração no painel
----------------------

Use o módulo **Configuração** para as opções globais suportadas que o MagnusBilling
expõe. Leia a ajuda contextual do campo antes de gravar um valor que você não
conhece. As mudanças podem afetar tarifação, autenticação, e-mail, campanhas e
processamento de chamadas.

Configuração da aplicação
-------------------------

Os principais pontos de entrada da aplicação são:

* ``protected/config/main.php`` para a aplicação web;
* ``protected/config/cron.php`` para os comandos agendados e de console;
* ``/etc/asterisk/res_config_mysql.conf`` para a conexão com o banco usada pelo
  sistema instalado.

Não coloque credenciais em documentação pública, relatos de issue ou capturas de
tela. Faça backup dos arquivos antes de alterá-los e preserve o dono e as permissões.

Asterisk 20 e PJSIP
-------------------

As instalações novas do MBilling 8 usam PJSIP. O instalador cria o ``pjsip.conf``
principal e inclui arquivos de configuração gerenciados pelo MagnusBilling, como:

* ``/etc/asterisk/pjsip_magnus.conf`` para a configuração de servidores e troncos;
* ``/etc/asterisk/pjsip_magnus_user.conf`` para os endpoints dos clientes.

Alguns arquivos são gerados de novo a partir dos dados do painel. Prefira alterar o
registro correspondente no MagnusBilling a editar direto um endpoint gerado.
Mudanças manuais nos arquivos gerados podem ser substituídas num próximo salvamento
ou atualização.

Procedimento seguro de mudança
------------------------------

1. Faça backup do banco e do ``/etc/asterisk``.
2. Anote o valor original e o motivo da mudança.
3. Mude uma camada de cada vez.
4. Recarregue ou reinicie só o serviço afetado.
5. Teste o login, as chamadas recebidas, as chamadas feitas, a tarifação e as tarefas
   agendadas, conforme o caso.
6. Confira os logs da aplicação e do Asterisk antes de passar o tráfego de produção.

Para as considerações sobre a migração do SIP, veja :doc:`Novidades do MBilling 8 <whats_new_mb8>`.
