# Suporte

## Escolha o canal certo

### Erros

Use as [GitHub Issues](https://github.com/magnussolution/magnusbilling/issues) quando o
código atual do MagnusBilling se comportar de forma errada e o problema puder ser
reproduzido. Procure antes; depois informe a versão ou o commit, o sistema operacional,
o comportamento esperado, o comportamento real, uma reprodução mínima e logs sem dados
sensíveis.

Erros nas customizações da Comunic (pastas `comunic/` e `custom/`) devem ser tratados
neste repositório, e não no projeto oficial.

### Pedidos de funcionalidade

Abra um pedido de funcionalidade no GitHub descrevendo o problema do operador e o
resultado desejado. Inclua, quando relevante, o impacto em compatibilidade, banco,
tarifação, telefonia e segurança.

### Instalação e configuração

Use a documentação do projeto e os canais da comunidade:

- [Wiki do MagnusBilling 8 no GitHub](https://github.com/magnussolution/magnusbilling/wiki)
- [Site do MagnusBilling](https://magnusbilling.org)
- [Canal no YouTube](https://www.youtube.com/channel/UCish_6Lxfkh29n4CLVEd90Q)
- [Telegram — inglês](https://t.me/joinchat/NXwoZRPGpG6rPqp3yssLzQ)
- [Telegram — espanhol](https://t.me/joinchat/NXwoZRXQbjokWrliVGObkQ)
- [Telegram — português](https://t.me/joinchat/NXwoZQtJRKN-5e03uY6_XQ)

O suporte da comunidade é feito na medida do possível. Não publique senhas, tokens de
API, chaves privadas, dumps completos do banco, CDRs sem tratamento ou informações de
clientes.

### Segurança

Possíveis vulnerabilidades devem ser comunicadas em particular, conforme o
[SECURITY.md](SECURITY.md). Issues públicas com detalhes exploráveis podem ser removidas
para proteger os operadores.

## Informações úteis para diagnóstico

Antes de pedir ajuda, reúna:

- a versão do MagnusBilling ou o commit do Git;
- a distribuição Linux e sua versão;
- as versões do PHP, MariaDB e Asterisk;
- se a implantação é nova ou migrada da versão 7;
- o fluxo afetado e o horário exato, com fuso horário;
- os logs relevantes da aplicação, do Apache, do MariaDB e do Asterisk, sem dados
  sensíveis;
- a menor configuração necessária para reproduzir o problema.

Troque IPs públicos, números de telefone, nomes de contas, cabeçalhos de autorização,
tokens e credenciais por marcadores consistentes. Não remova a mensagem de erro nem a
sequência necessária para entender a falha.
