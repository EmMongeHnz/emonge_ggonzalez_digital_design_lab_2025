## Problema 1:
**Propuesta 1:** Para la solución de este problema se parte de la definición donde para pasar de código binario a Gray deben seguirse las siguiente reglas:

1. El dígito más significativo es el mismo tanto en código binario como en código Gray.
2. De izquierda a derecha, cada par adjacente de numeros se suma (descartando acarreo si hubiese) para obtener el siguiente dígito del equivalente en código Gray.

Para cumplir con estas premisas el operador lógico **XOR** es ideal. Para un **XOR** de dos entradas (A,B) con un resultado (Z), su comportamiento se ajusta perfectamente a un sumador que ignora el acarreo:

|A|B|Z|
|:-:|:-:|:-:|
|0|0|0|
|0|1|1|
|1|0|1|
|1|1|0|

Con esto en mente la primera regla es fácil de cumplir ya que sólo consiste en conservar el valor del bit más significativo en el resultado final.

Respecto a la segunda regla, esta se cumple al realizar la operación **XOR** ($\oplus$) de izquierda a derecha con cada par de dígitos. También es posible realizar esta operación de derecha a izquierda de menos significativo a más significativo (en el caso del último bit, al hacerse un **XOR** con cero se cumpliría la primera regla de forma automática), esto ya depende de como se defina la relación de significancia entre los bits.

## Problema 2:

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

## Problema 3:

**Propuesta 1:**  Para la solución de este problema se utilizan 4 un flip-flops con respuesta en bajada conectados en cascada, los cuales van a almacenar un bus de datos de N bits. El primer flip-flop responde a los impulsos del reloj y el resto responden al impulso del anterior, Generando así el contador y dejando la siguiente tabla de verdad:

| Q0 | Q1 | Q2 | Q3 | CLR |
|:--:|:--:|:--:|:--:|:---:|
| 0  | 0  | 0  | 0  |  1  |
| 0  | 0  | 0  | 1  |  1  |
| 0  | 0  | 1  | 0  |  1  |
| 0  | 1  | 1  | 1  |  1  |
| 1  | 1  | 0  | 0  |  1  |
| 1  | 1  | 0  | 1  |  1  |
| 1  | 0  | 1  | 0  |  1  |
| 1  | 0  | 1  | 1  |  1  |
| 0  | 0  | 0  | 0  |  1  |
| 0  | 1  | 0  | 1  |  1  |
| ...  | ...  | ...  | ...  |  0  |



