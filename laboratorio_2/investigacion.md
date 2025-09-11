1. **Investigue sobre el funcionamiento general de una ALU. Muestra tablas de verdad y diagramas de circuitos lógicos y aritméticos simples (sumas, restas, operaciones lógicas etc.). Incluya una descripción de las banderas de estado de una ALU, por ejemplo las de la
arquitectura ARMv4.**

La ALU (Unidad Aritmética Lógica) consiste en la junta de una unidad aritmética encargada de los procesos matemáticos como la suma, resta, multiplicación y división y la unidad lógica encargada de gestionar operaciones lgicas como (NOT, AND, OR). Estas operaciones se realizan según las siguientes tablas de verdad:

**Suma**
| A | B | Suma (S) | Carry (Cout) |
| - | - | -------- | ------------ |
| 0 | 0 | 0        | 0            |
| 0 | 1 | 1        | 0            |
| 1 | 0 | 1        | 0            |
| 1 | 1 | 0        | 1            |

**Resta**
| A | B | Resta (D) | Borrow (Bout) |
| - | - | --------- | ------------- |
| 0 | 0 | 0         | 0             |
| 0 | 1 | 1         | 1             |
| 1 | 0 | 1         | 0             |
| 1 | 1 | 0         | 0             |

**OR**
| A | B | OR (S) |
| - | - | ------ |
| 0 | 0 | 0      |
| 0 | 1 | 1      |
| 1 | 0 | 1      |
| 1 | 1 | 1      |

**AND**
| A | B | AND (S) |
| - | - | ------- |
| 0 | 0 | 0       |
| 0 | 1 | 0       |
| 1 | 0 | 0       |
| 1 | 1 | 1       |


 Inicialmente la ALU recibe dos numeros y una orden de la unidad de control, luego la unidad de control se encarga de especificar la operación a realizar. Finalmente se envía el resultado a un registro y se activa el indicador de estado (En caso de desbordamiento, numero negativo etc.)

 **Banderas de estado de la ALU**
 - N (Negative): Se activa si el bit más significativo del resultado es 1, indicando que el resultado es negativo en complemento a dos.  
- Z (Zero): Se activa si el resultado de la operación es cero.  
- C (Carry): En suma, indica un acarreo desde el bit más significativo; en resta, indica que no hubo préstamo.  
- V (Overflow): Se activa si ocurre desbordamiento aritmético, es decir, cuando el resultado no puede representarse correctamente con signo en complemento a dos.  


2. **Explique los conceptos de tiempos de propagación y tiempos de contaminación, en circuitos combinacionales.**
En un circuito combinacional, el **tiempo de propagación (t_pd)** es el tiempo máximo que tarda una señal en viajar desde una entrada hasta que la salida refleja correctamente el cambio. Representa el peor caso y se usa para calcular la velocidad máxima del sistema.  
Por otro lado, el **tiempo de contaminación (t_cd)** es el tiempo mínimo que tarda un cambio en la entrada para comenzar a afectar la salida. Representa el mejor caso y es clave para analizar posibles glitches o problemas de sincronización.  


3. **Investigue sobre la ruta crítica y cómo esta afecta en el diseño de sistemas digitales más complejos, por ejemplo un procesador con pipeline. Investigue su relación con la frecuencia máxima de operacián de un circuito**
La **ruta crítica** es el camino más lento por el que viaja una señal dentro del circuito, sumando todos los retardos de propagación de las compuertas por las que pasa. Esta ruta determina la **frecuencia máxima de operación** del sistema, ya que un ciclo de reloj no puede ser más rápido que el tiempo que tarda en completarse esta ruta.  
En procesadores con **pipeline**, dividir el trabajo en etapas más cortas reduce el tiempo de la ruta crítica por etapa, lo que permite **aumentar la frecuencia de operación** y mejorar el rendimiento global del sistema.
