# LedsFinal
Microcontroladores-Practica de laboratorio 5 

##Funcionamiento del proyecto
En esta práctica, se ha trabajado con una placa de desarrollo blue pill Stm32 y un grabador St-Link V2, así como con jumpers, 8 leds y 2 push buttons; El hardware funciona de tal forma que al grabar el código en ensamblador en la blue pill se muestra en los ocho leds los números escritos en binario, es decir, para el caso en el que se represente el número 1 en binario se mostrará un 01 en los leds, donde el led encendido indica uno y el led apagado indica 0 en binario. Los botones funcionan de tal forma que al presionar un botón se decremetará el conteo, mientras que al presionar otro botón se hará un aumento en el conteo de uno en uno y al presionar ambos botones al mismo tiempo se reseteará el conteo apagando todos los leds (Porque el 0 en binario es 0000 0000).

## Diagrama del proyecto
El siguiente diagrama representa las conexiones hechas en la placa utilizada para este proyecto, se hizo uso de una blue pill

![logo](https://i.ibb.co/c1n86S3/Leds-Final.png)

En este diagrama se muestra la correcta configuración del hardware para que funcione correctamente el proyecto aquí presentado. Se deben conectar 8 leds a del puerto B8 al puerto B15 tal y como se aprecia en el diagrama. Además deben de conectarse sus correspondientes resistencias a cada led, donde cada resistencia se encontrará conectada a tierra; Y por último, se debe conectar con un jumper en la parte de la blue pill que indica 3.3 para poder conectar los botones.

## Procedimiento de compilación
En primera instancia necesitamos conectar la placa a nuestro ordenador para verificar que el sistema operativo la reconoce. Para esto, se hizo uso del software STM32CubeProgrammer para hacer el reconocimiento de la placa. Una vez hecho esto, iremos a nuestro Visual Studio Code o directamente desde la terminal de Ubuntu (wsl) para ejecutar los comandos correspondientes para obtener el archivo binario que grabaremos en nuestra placa.
Primero, ensamblamos el contenido del archivo leds.s a través del siguiente comando:

```
arm-as leds.s -o leds.o
```

Después, una vez generado el archivo leds.o, construiremos un objeto binario a partir del archivo blink.o, esto lo haremos con el comando siguiente:

```
arm-objcopy -O binary leds.o leds.bin
```

Finalmente, una vez hecho este procedimiento, haciendo uso del STM32CubeProgrammer simplemente conectamos el grabador con la blue pill y damos click en la parte superior derecha en Connect y buscamos el apartado de Erasing & Programmingy, buscamos nuestro archivo leds.bin y damos clic en Start Programming para realizar el grabado del programa en nuestra placa.
