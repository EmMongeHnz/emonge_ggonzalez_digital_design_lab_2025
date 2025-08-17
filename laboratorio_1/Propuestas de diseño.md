## Problema 1: ##

## Problema 2: ##

**Propuesta 1:** Para la solución de este problema se parte de un restador completo de 1 bit. El cual funciona como un circuito de 3 entradas y 2 salidas, la primera entrada es el **borrow in**, la segunda es el minuendo (A) y la tercera el sustraendo (B). En el caso de las salidas el primer bit de salida representa el **borrow out** y el segundo el resultado de la resta (R). Los **borrows** lo que representan es si se necesitó un *prestamo* durante la resta, ya que al restar numeros binarios se mantiene la logica en la que es imposible quitarle 1 a 0, por lo tanto se requiere añadir un uno a ese cero para poder continuar la operación, en caso de que el *prestamo* se realice el **borrow out** es 1 y en caso de no ser necesario pasa a ser 0. Por el parte del **borrow in**, este inicia siendo 0 y a partir de ahí va a tomar el valor del **borrow out** anterior. Con esto explicado, la tabla de verdad se sería la siguiente:

| Bin | A | B | Bout | R |
|:---:|:-:|:-:|:----:|:-:|
|  0  | 0 | 0 |   0  | 0 |
|  0  | 0 | 1 |   1  | 1 |
|  0  | 1 | 0 |   0  | 1 |
|  0  | 1 | 1 |   0  | 0 |
|  1  | 0 | 0 |   1  | 1 |
|  1  | 0 | 1 |   1  | 0 |
|  1  | 1 | 0 |   0  | 0 |
|  1  | 1 | 1 |   1  | 1 |

Al obtener los minterminos y realizar las operaciones correspondientes podemos ver que el circuito final se compone de 2 compuertas **XOR** conectadas en cascada por parte de R y 2 compuertas **NOT** conectadas a 3 **AND** en cascada y 1 **OR** en el caso de Bout. 

Finalmente, como el problema propuesto es un restador de 4 bits, se propone conectar 4 restadores de 1 bit en cascada.

## Problema 3: ##



