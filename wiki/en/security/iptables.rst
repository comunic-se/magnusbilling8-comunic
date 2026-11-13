*****************
Iptables
*****************

Regras de Iptables aplicadas na instalação.

Regras básicas
^^^^^^^^^^^^^^

::
     
  	iptablesF
	iptablesA INPUT -p icmp --icmp-type echo-request -j ACCEPT
	iptablesA OUTPUT -p icmp --icmp-type echo-reply -j ACCEPT
	iptablesA INPUT -i lo -j ACCEPT
	iptablesA INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
	iptablesA INPUT -p tcp --dport 22 -j ACCEPT
	iptablesP INPUT DROP
	iptablesP FORWARD DROP
	iptablesP OUTPUT ACCEPT
	iptablesA INPUT -p udp -m udp --dport 5060 -j ACCEPT
	iptablesA INPUT -p udp -m udp --dport 10000:20000 -j ACCEPT
	iptablesA INPUT -p tcp -m tcp --dport 80 -j ACCEPT

Regras opcionais
^^^^^^^^^^^^^^^^

| OPENVPN: ``iptables -A INPUT -p udp --dport 1194 -j ACCEPT`` 
| ICMP: ``iptables -A INPUT -p icmp --icmp-type echo-request -j ACCEPT``
| IAX: ``iptables -A INPUT -p udp -m udp --dport 4569 -j ACCEPT``
| HTTPS: ``iptablesA INPUT -p tcp -m tcp --dport 443 -j ACCEPT``

Friendly Scanner
^^^^^^^^^^^^^^^^^

Regras para bloquear o "friendly scanner", que não é nada amigável

::
     
	iptables -I INPUT -j DROP -p tcp --dport 5060 -m string --string "friendly-scanner" --algo bm
	iptables -I INPUT -j DROP -p tcp --dport 5080 -m string --string "friendly-scanner" --algo bm
	iptables -I INPUT -j DROP -p udp --dport 5060 -m string --string "friendly-scanner" --algo bm
	iptables -I INPUT -j DROP -p udp --dport 5080 -m string --string "friendly-scanner" --algo bm

| *Opcional*


::
     
	iptables -I INPUT -j DROP -p tcp --dport 5060 -m string--string "VaxSIPUserAgent" --algo bm
	iptables -I INPUT -j DROP -p udp --dport 5060 -m string --string "VaxIPUserAgent" --algo bm
	iptables -I INPUT -j DROP -p udp --dport 5080 -m string --string "VaxSIPUserAgent" --algo bm
	iptables -I INPUT -j DROP -p tcp --dport 5080 -m string --string "VaxIPUserAgent" --algo bm


Mostrar as regras do iptables
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
::
     
  sudo iptables -L -v

Mostrar os números das linhas
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

::
     
  iptables -L -v --line-numbers

Apagar uma linha
^^^^^^^^^^^^^^^^

Apagar a linha 2

::
     
  iptables -D INPUT 2

Bloquear um endereço IP
^^^^^^^^^^^^^^^^^^^^^^^

::
     
  iptables -I INPUT -s 62.210.245.132 -j DROP

Gravar as mudanças
^^^^^^^^^^^^^^^^^^
     
	apt-get install iptables-persistent
	service iptables-persistent save
	dpkg-reconfigure iptables-persistent


