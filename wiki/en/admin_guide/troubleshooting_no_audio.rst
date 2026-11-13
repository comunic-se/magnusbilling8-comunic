Solução de problemas: chamadas sem áudio
========================================

Quando a chamada conecta mas o som/áudio não passa, na maioria dos casos o problema está na **configuração de RTP/NAT/firewall**, e não na tarifação.

Confira o seguinte:

1. **Libere as portas RTP no firewall do servidor**
   O MagnusBilling já vem com essas portas liberadas, mas se você tem uma configuração de firewall própria, confirme que estas portas estão abertas:

```bash
10000:60000/udp
```

Confira se estão abertas no firewall do servidor, no firewall do provedor de nuvem, no roteador ou no security group.

2. **Confira as configurações de NAT do Asterisk**

Edite:

```bash
/etc/asterisk/sip.conf
```

Confirme que o servidor está com o IP público correto, por exemplo:


* externip=IP_PUBLICO_DO_SERVIDOR
* localnet=SUA_REDE_LOCAL/MASCARA
* nat=force_rport,comedia


Depois recarregue o Asterisk:

```bash
asterisk -rx "sip reload"
```

3. **Confira se os pacotes RTP estão chegando**

Rode este comando durante uma chamada de teste:

```bash
tcpdump -n udp portrange 10000-60000
```

Se não aparecerem pacotes RTP, o áudio está sendo bloqueado antes de chegar ao servidor.

4. **Desative a mídia direta, se for preciso**

Com a mídia direta ativada, o áudio pode tentar passar direto entre quem liga e o provedor, causando áudio de um lado só ou nenhum áudio, dependendo do NAT.

Nas opções do MagnusBilling / Asterisk, teste com **directmedia desativado**.

Documentação:
https://wiki.magnusbilling.org/en/source/get_started/first_call.html#directmedia

5. **Teste com outro provedor ou outra conta SIP**

Isso ajuda a confirmar se o problema está:

* no aparelho/softphone do cliente,
* no tronco do provedor,
* no firewall/NAT,
* ou na configuração do servidor.

Documentação útil:
https://wiki.magnusbilling.org/en/source/get_started/first_call.html
https://wiki.magnusbilling.org/en/source/get_started/quick_install.html

Se depois dessas conferências o problema continuar, envie para nós:

* a data/hora de uma chamada de exemplo,
* o número de quem ligou,
* o número de destino,
* o provedor usado,
* e se falta áudio nos dois sentidos ou só num sentido.
