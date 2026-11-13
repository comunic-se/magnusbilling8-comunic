Restringir o login no painel por IP autorizado via SSH
======================================================

O MagnusBilling pode restringir o login no painel web de qualquer usuário aos
endereços IP autorizados a partir de uma sessão SSH. A lista de IPs permitidos fica
fora da raiz de documentos web e fora do MariaDB, em
``/etc/magnusbilling/panel-ip-access``.

Ativar a restrição
------------------

Conecte-se por SSH a partir do mesmo IP público usado pelo navegador e rode::

   addmyip root

O comando obtém o endereço do cliente a partir da própria conexão SSH. Ele não
aceita um IP informado na linha de comando. A primeira execução bem-sucedida cria
uma lista de IPs própria do usuário e ativa a restrição para ele. Os usuários
existentes continuam sem restrição até este comando ser rodado com o nome exato
de cada um.

O comando também remove o IP do cliente SSH da ``pkg_firewall`` e da ``pkg_log`` e
depois o insere na ``pkg_firewall`` com a ação ``5`` (``IgnoreIP``). Essas operações
no banco rodam numa transação; se falharem, a lista de IPs do painel não é alterada.

Qualquer usuário do painel pode ser usado, por exemplo::

   addmyip administrator
   addmyip "support manager"

Cada usuário tem uma lista independente. Os usuários são representados por um
identificador SHA-256 no diretório de armazenamento, para que caracteres especiais
não sejam interpretados como caminhos de arquivo.

Remover o IP atual
------------------

A partir da sessão SSH cujo endereço deve ser removido, rode::

   delmyip root

A restrição continua ativa mesmo quando o último endereço é removido. Nesse caso,
nenhum IP consegue entrar no painel web com esse usuário até que ``addmyip USUARIO``
seja rodado pelo SSH ou todas as restrições sejam liberadas.

Desativar todas as restrições por IP
------------------------------------

Rode::

   releaseAll

Isso remove todos os arquivos de lista de IPs do painel e deixa todos os usuários
sem restrição de novo. Os três comandos exigem privilégios de ``root``.

Proxies reversos e VPNs
-----------------------

O login web compara o endereço confiável do cliente no Apache (``REMOTE_ADDR``) com o
endereço do cliente SSH. Se um proxy reverso, CDN, gateway NAT ou VPN fizer os dois
endereços serem diferentes, configure o ``mod_remoteip`` do Apache só com as faixas
de proxy confiáveis, ou conecte-se ao SSH pelo mesmo caminho de saída. Não confie em
cabeçalhos ``X-Forwarded-For`` arbitrários.
