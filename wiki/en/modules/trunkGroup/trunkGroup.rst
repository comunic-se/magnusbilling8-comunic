
.. _trunkGroup-name:

Nome
----

| Nome do grupo de troncos.




.. _trunkGroup-type:

Tipo
----

| Tipo.
| É como o sistema ordena os troncos que pertencem ao grupo.
|
| \* Em ordem. O sistema manda a chamada para os troncos na ordem selecionada.
| \* Aleatório. O sistema ordena os troncos de forma aleatória, com a função RAND() do MySQL; por isso, o mesmo tronco pode se repetir em sequência.
| \* LCR. Ordena os troncos pelo menor custo. Se o dono do tronco não tiver tarifa, o tronco é ignorado e colocado por último.
|
| O MagnusBilling manda as chamadas para os troncos deste grupo até que sejam atendidas, dêem ocupado ou sejam canceladas.
|
| O MagnusBilling tenta o próximo tronco do grupo enquanto o tronco testado responder CHANUNAVAIL ou CONGESTION; esses valores são devolvidos pelo Asterisk e não podem ser alterados.
|
|
|
|




.. _trunkGroup-weight:

Peso
----

| Esta opção distribui as chamadas por peso.
| Exemplo.
|
| Digamos que você selecionou 3 troncos e quer mandar 1 chamada para o primeiro, 2 para o segundo e 1 para o terceiro; nesse caso, coloque 1,2,1 neste campo.




.. _trunkGroup-id-trunk:

Troncos
-------

| Selecione os troncos que pertencem a este grupo. Se o tipo for "em ordem", selecione os troncos na ordem desejada.



