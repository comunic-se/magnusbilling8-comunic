
.. _phoneNumber-id-phonebook:

Agenda
------

| Agenda à qual este número pertence.




.. _phoneNumber-number:

Número
------

| Número para enviar chamadas/SMS. Sempre no formato E164.




.. _phoneNumber-name:

Nome
----

| Nome do dono do número, usado em TTS ou SMS.




.. _phoneNumber-doc:

Documento
---------

| Documento do cliente (CPF/CNPJ ou equivalente) associado a este número.




.. _phoneNumber-city:

Cidade
------

| Cidade do cliente; campo não obrigatório.




.. _phoneNumber-email:

E-mail
------

| Endereço de e-mail do cliente associado a este número.




.. _phoneNumber-status:

Status
------

| O MagnusBilling só tenta enviar quando o status é ativo.
| Quando a chamada é enviada ao provedor, o número fica com status pendente.
| Se a chamada for completada, o status muda para enviado.
| Caso contrário, continua pendente, o que significa que o tronco recusou a chamada ou a encerrou por algum motivo.
| Se a opção "números bloqueados" estiver ativada na campanha e o número estiver cadastrado no menu "Chamadas e SMS", submenu "Números restritos", o status fica bloqueado.
| Use o botão "processar" para reativar os números com status pendente.




.. _phoneNumber-info:

Descrição
---------

| Descrição na agenda, apenas para controle interno.
| Quando usado em pesquisa, guarda aqui o número que o cliente digitou.



