.. _price-calculation:

Cálculo do preço da chamada
===========================



Este valor é calculado com base no preço ajustado para o provedor cujo tronco foi usado para completar a chamada.

O preço é calculado com 4 valores:

* duração da chamada;
* preço de compra;
* bloco inicial;
* incremento.

Exemplo.

O cliente liga para o número 5511988443300 e fala por 45 segundos.
E existe uma tarifa no menu Tarifas de provedores para o prefixo 55119, com:

* Preço de compra = 0,05
* Bloco inicial = 30
* Incremento = 6

A fórmula de cálculo é:

Se a duração da chamada for menor que o bloco inicial, a fórmula é

::

  (Preço de compra / 60 segundos) * Bloco inicial


Se a duração da chamada for maior que o bloco inicial, a fórmula é


::

  (Preço de compra / 60 segundos) * Duração da chamada


Quando a duração da chamada é maior que o bloco inicial, o incremento também entra no cálculo.

No exemplo, a duração foi de 45 segundos e o incremento é 6, então a fórmula fica

::

  (Duração da chamada / Incremento): o resultado é 7, com resto 3. Então somamos 3 para completar o bloco, e o resultado é 48. Neste exemplo, o cálculo fica

::

  (0,05 / 60) * 48 = 0,04



O código abaixo é o usado no cálculo.

.. code-block:: php

   $cost = 0;
   if ($callduration < $initblock) {
       $callduration = $initblock;
   }

   if (($billingblock > 0) && ($callduration > $initblock)) {
       $mod_sec = $callduration % $billingblock;
       if ($mod_sec > 0) {
           $callduration += ($billingblock - $mod_sec);
       }
   }
   $cost += ($callduration / 60) * $rateinitial;


A variável $callduration é a duração da chamada;
a variável $initblock é o bloco inicial;
a variável $billingblock é o incremento.
