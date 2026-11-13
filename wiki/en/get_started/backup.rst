******
Backup
******

É sempre bom ter um backup.

O backup padrão deixa de fora, de propósito, os dados de várias tabelas grandes de
histórico. Isso mantém os backups de rotina num tamanho administrável, mas também
significa que o backup padrão não é um backup completo para migração.

.. warning::

   Não use só o menu Backup ou o comando de console ``Backup`` ao migrar do
   MagnusBilling 7 para o MagnusBilling 8. Siga o
   :doc:`guia de migração do MagnusBilling 7 <migrate_from_mb7>` e faça um dump
   completo do banco se o histórico de CDR precisar ser preservado.

Backup manual
^^^^^^^^^^^^^

O projeto já tem um script para fazer backup do banco de dados e dos arquivos do Asterisk.
A instalação já coloca um script no crontab do Linux que faz um backup por dia. O padrão é às 02:00.

Manualmente
^^^^^^^^^^^

Rode este comando no SHELL do servidor:
php /var/www/html/mbilling/cron.php Backup

Crontab
^^^^^^^

Editando com crontab -e

::

 crontab -e

Procure a linha abaixo e mude o horário como preferir, ou comente a linha para não fazer backups automáticos.

::

 0 2 * * * php /var/www/html/mbilling/cron.php Backup

Menu Backup
^^^^^^^^^^^

Também é possível ver, baixar e apagar backups pelo menu Backup, que fica em Configurações.
