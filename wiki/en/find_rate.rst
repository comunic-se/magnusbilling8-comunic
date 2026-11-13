.. _find-rate:

Busca de tarifa
===============

Como o MagnusBilling escolhe a tarifa a usar?
---------------------------------------------

Quando um cliente faz uma chamada externa, para fixo ou celular, é disparada uma rotina de verificação que consiste em:

1. Conferir o usuário e a senha.
2. Conferir se o cliente está ativo.
3. Conferir se o número discado é um DID.
4. Conferir se o número discado é uma conta SIP.
5. Conferir o plano do cliente.
6. Procurar, entre as tarifas do plano, a que melhor se encaixa no número discado.
7. Procurar os troncos que pertencem ao grupo de troncos da tarifa encontrada.
8. Mandar a chamada para o primeiro tronco e, se falhar, para o próximo.
9. Ao terminar a chamada, calcular o preço de compra e de venda.
10. Acrescentar a chamada ao relatório de CDR.
11. Descontar o valor da chamada do crédito do cliente.


E como funciona o passo 6?

Funciona assim. Digamos que o cliente XXXXX ligou para 551140045678.

No passo 5, o sistema pega o plano do cliente e, no passo 6, faz um "SELECT" na tabela de tarifas assim:


::

 $ sql = "SELECT * FROM pkg_plan LEFT JOIN pkg_rate ON pkg_plan.id = pkg_rate.id_plan
 LEFT JOIN pkg_prefix ON pkg_rate.id_prefix = pkg_prefix.id
 LEFT JOIN pkg_trunk_group ON pkg_trunk_group.id = pkg_rate.id_trunk_group
 WHERE pkg_plan.id = $ MAGNUS-> id_plan AND pkg_rate.status = 1
 AND $ MAGNUS-> prefixclause ORDER BY LENGTH (prefix) DESC LIMIT 1 ";


A variável $ MAGNUS-> id_plan é o id do plano do cliente, e a variável $ MAGNUS-> prefixclause é o filtro usado para achar a tarifa.

Para facilitar, vamos explicar de outro jeito.

Como o cliente ligou para 551140045678, o sistema procura assim:

Existe tarifa para o prefixo 551140045678?

* Se sim, usa essa tarifa.

* Se não, procura de novo tirando o último dígito, neste caso 55114004567, e assim por diante até sobrar só o número 5. Se não achar nenhuma tarifa, o sistema devolve um erro e não continua a chamada.



Voltando ao "SELECT", ele fica assim:

::

 $ sql = "SELECT * FROM pkg_plan LEFT JOIN pkg_rate ON pkg_plan.id = pkg_rate.id_plan
 LEFT JOIN pkg_prefix ON pkg_rate.id_prefix = pkg_prefix.id
 LEFT JOIN pkg_trunk_group ON pkg_trunk_group.id = pkg_rate.id_trunk_group
 WHERE pkg_plan.id = 1 AND pkg_rate.status = 1 AND
 (prefix = '551140045678' OR
 prefix = '55114004567' OR
 prefix = '5511400456' OR
 prefix = '551140045' OR
 prefix = '55114004' OR
 prefix = '5511400' OR
 prefix = '551140' OR
 prefix = '55114' OR
 prefix = '5511' OR
 prefix = '551' OR
 prefix = '55' OR
 prefix = '5')
 ORDER BY LENGTH (prefix) DESC LIMIT 1 ";


Digamos que o plano do cliente tenha estas 3 tarifas:

55, Brasil Fixo Geral
55119, Brasil SP Celular
5511, Brasil SP Fixo


Neste exemplo, o "SELECT" devolveria a tarifa 5511, Brasil SP Fixo.



Mas e se o cliente ligar para 5511988551234? O "SELECT" acharia os prefixos 55119 e 5511; qual seria usado? O 55119, porque o "SELECT" tem o parâmetro ORDER BY LENGTH (prefix) DESC e também o parâmetro LIMIT 1. Ou seja, ordena os resultados colocando primeiro o prefixo com mais dígitos.
