## Problema 1:

**Suma:**
**Resta:** Para el diseño de la resta se parte del concepto matemático de la misma, utilizando una tabla de verdad de 4 bits se ejecuta la resta de A - B. Sin embargo, al realizar la operación 0 - 1 naturalmente quedaría un resultado negativo, pero en el sistema binario solamente se pueden usar 0 y 1. Por lo tanto, para representar un resultado negativo se utiliza un bit de acarreo de salida (Cout) el cual se activa si la resta es menor a 0. Adicional a esto, se debe utilizar un bit de acarreo de entrada (Cin) el cual se activa si el bit de acarreo anterior estaba activo. De esta manera se puede representar el comportamiento de la resta respetando sus respectivos acarreos y en caso de que el ultimo bit de acarreo esté activo esto activaría la flag de negativo, mostrando así que el resultado de la resta es menor que 0. Al realizar las restas con su respectivo bit de acarreo se obtiene la siguiente tabla de verdad la cual se puede resumir en el diagrama de compuertas que se muestran posteriormente.

| Cin | A | B | Cout | R |
|---|---|---|-------|-------|
| 0 | 0 | 0 |   0   |   0   | 
| 0 | 0 | 1 |   1   |   0   | 
| 1 | 1 | 0 |   1   |   1   |  
| 1 | 1 | 1 |   0   |   1   | 

![](imgs/cap.png)
