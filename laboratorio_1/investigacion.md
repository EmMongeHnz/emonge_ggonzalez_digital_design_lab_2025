1. **Explique el modelado de comportamiento y de estructura en diseño digital, Brinde un ejemplo de cada uno.**

    El modelado de comportamiento describe, tal como su nombre lo indica, cómo se comporta o qué hace un determinado módulo. Por otro lado, el modelado de estructura, describe un módulo complejo y cómo este está constituido de partes más sencillas.    

2. **Explique el proceso de síntesis lógica en el diseño de circuitos digitales.**

    La síntesis lógica parte de código HDL, el cual es luego transformado en un "mapa" que describe el hardware y sus interconexiones. Este "mapa" puede ser un archivo de texto o también puede ser mostrado en forma de esquemático de forma que sea posible visualizar el circuito que se programó.

3. **Investigue sobre la tecnología de FPGAs. Describa el funcionamiento de la lógica programable en general, así como los componentes básicos de una.**

    Los FPGAs pertenecen a la familia de componentes con lógica programable. La base de esta lógica programable se sustenta en una matriz de bloques lógicos configurables. Estos bloques a su vez están enlazados por medio de una red de interconexiones completamente reprogramable. Celdas de memoria controlan los bloques lógicos así como las conexiones de forma que el componente logre cumplir con los requerimientos. También se tienen bloques de entrada/salida (I/O) para conexiones externas, mostrar resultados, etc.


4. **Investigue sobre los actuales modelos de FPGA utilizados en las industrias.**
Actualmente, los modelos de FPGA más utilizados en la industria provienen de AMD (Xilinx) con sus familias Virtex, Kintex, Artix, Spartan y Zynq, muy populares por cubrir desde aplicaciones de bajo costo y consumo hasta sistemas de alto rendimiento e integración con procesadores ARM. Intel Agilex destaca en centros de datos y telecomunicaciones por su gran capacidad de procesamiento y flexibilidad, mientras que Lattice es preferida en IoT y dispositivos de borde por su eficiencia energética. Finalmente, Microchip/Actel con sus PolarFire e IGLOO son comunes en aeroespacial y defensa por su fiabilidad y tolerancia a entornos extremos.


5. **Investigue sobre cuáles son las aplicaciones más comunes en la industria que tienen las FPGA.**

En la actualidad las FPGA son utilizadas para el procesamiento de señales digitales (DSP), principalmente en telecomunicaciones y aplicaciones de imagen y video. Otro uso común es la aceleración de computo, se utilizan como aceleradores de hardware en varios centros de datos (Azure, Amazon, AWS). En sistemas criticos como lo pueden ser aeroespaciales y de defensa, cumplen un rol importante pues se pueden reprogramar tras su fabricación, aumentando su vida util.
