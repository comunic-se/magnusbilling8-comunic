**************************
Atualizar o MagnusBilling
**************************

Nossa equipe trabalha todos os dias para acrescentar funções e resolver problemas. Você pode ver as mudanças feitas no link https://github.com/magnussolution/magnusbilling/commits/source.

Por isso, nossa equipe recomenda manter o servidor atualizado.

Para atualizar, rode o comando abaixo.


::

 /var/www/html/mbilling/protected/commands/update.sh

.. warning::

   Este comando atualiza uma instalação existente do MagnusBilling 8. Ele não
   converte um servidor MagnusBilling 7 em MagnusBilling 8. As instalações da
   versão 7 precisam usar o :doc:`procedimento de migração lado a lado <migrate_from_mb7>`.

.. note::

   Nos servidores com as customizações da Comunic, a atualização automática
   oficial fica desligada. Use ``bash /opt/mb8-comunic/comunic/atualizar-mb8.sh``,
   que confere a compatibilidade, faz backup e reaplica as customizações
   (veja ``comunic/README.md``).


Conferências depois da atualização
==================================

Depois de atualizar, confira as principais áreas que podem ser afetadas por mudanças
no código:

* Inicialização do painel web: ``index.php`` e ``protected/config/main.php``.
* Comandos de console: ``cron.php`` e ``protected/config/cron.php``.
* Migrações e mudanças de estrutura do banco: ``protected/commands/UpdateMysqlCommand.php`` e ``script/database.sql``.
* Comportamento do AGI do Asterisk: ``resources/asterisk/mbilling.php`` e os arquivos ``*Agi.php`` relacionados.
* Arquivos do frontend e dos módulos: ``app/`` e ``classic/src/view/``.

Se um módulo aparece no código-fonte mas não no painel web, confira também as
permissões do grupo nas configurações de menu e de módulos do grupo.
