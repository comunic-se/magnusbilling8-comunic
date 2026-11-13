
.. _firewall-ip:

IP
--

| Endereço IP.




.. _firewall-action:

Ação
----

| Com esta opção em SIM, o IP é colocado na lista de bloqueio (ip-blacklist) do fail2ban e fica bloqueado permanentemente.
| A opção NÃO bloqueia o IP temporariamente, de acordo com os parâmetros do /etc/fail2ban/jail.local.
|
|     Por padrão, o IP fica bloqueado por 10 minutos.




.. _firewall-description:

Descrição
---------

| Esta informação é lida do arquivo de log /var/log/fail2ban.log.
| Você pode acompanhar este log com o comando
|
|     tail -f /var/log/fail2ban.log



