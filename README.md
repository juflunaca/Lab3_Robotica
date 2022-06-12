# Laboratorio_3_inverse_kinematics_ROS
En este documento se explica el proceso para desarrollar la cinemática inversa del robot Px Phantom, de igual manera, se indica cómo se desarrollaron los algoritmos para manipular el robot entorno a una rutina pick and place a través del teclado.

Lab 3 Robótica

Elaborado por: 
- Javier Caicedo 
- Julián Luna.

## Objetivos:
- Determinar el modelo cinemático inverso del robot Phantom X.
- Generar trayectorias simples a partir del modelo cinemático inverso del robot.
- Implementar el modelo cinemático inverso del robot en MATLAB.
- Operar el robot usando ROS a partir de trayectorias generadas en MATLAB o Python.

## Requisitos:
- Ubuntu versión 20.xx preferible 20.04 LTS con ROS.
- Espacio de trabajo para catkin correctamente configurado.
- Paquetes de Dynamixel Workbench. https://github.com/fegonzalez7/rob_unal_clase3 
- Paquete del robot Phantom X: https://github.com/felipeg17/px_robot.
- MATLAB 2015b o superior instalado en el equipo.
- Robotics toolbox de Mathworks (Disponible desde la versión 2015 en adelante).
- Toolbox de rob´otica de Peter Corke.
- Piezas tipo 1 y 2 del proyecto (ver planos adjuntos).

## Cinemática Inversa del Phantom X:
El problema cinemático inverso consiste en determinar la configuración articular de un manipulador, dadas la posición y orientación del efector final respecto a la base. Este problema puede resolverse mediante métodos geométricos, algebraicos o numéricos. En el caso particular del robot Phantom X el cual posee 4 GDL, el enfoque más práctico es combinar el método geométrico con el desacople de muñeca.

## Modelo de cinemática inversa del manipulador en MATLAB:
A continuación se muestra el desarrollo alcanzado de la cinemática inversa en Matlab.
Definimos las longitudes de los eslabones, así como los parámetros de la cinemática directa para poder realizar las diferentes asociaciones entre los eslabones que conforman la cadena cinemática del Robot Phantom.

<p align="center"><img src="https://i.postimg.cc/kXx8jJBj/uno.png"</p>

Luego definimos las expresiones algebraicas que nos permiten calcular cada uno de los ángulos que definen la postura del robot con relación a la MTH definida como pos, que define la postura de la herramienta para la cual queremos hallar una solución mediante cinemática inversa, cabe señalar que estas soluciones se desprenden del análisis geométrico del sistema, en el cual se obtiene la solución codo arriba y codo abajo.

<p align="center"><img src="https://i.postimg.cc/sXv7K5hS/dos.png"</p>
  
Mostramos la solución y la graficamos con ayuda del teach.

<p align="center"><img src="https://i.postimg.cc/qMfyXhMh/tres.png"</p>
    
Obteniendo la siguiente representación.
 
<p align="center"><img src="https://i.postimg.cc/5yzvW1p2/cuatro.png"</p>  



### Análisis:
Sabiendo que el robot Phantom X posee 4 GDL, de los cuales 3 corresponden a posición, el GDL restante proporciona una medida independiente para un ángulo de orientación (asuma orientación en ángulos fijos).
- ¿De qué ángulo de orientación se trata?
- ¿Cuántas soluciones posibles existen para la cinemática inversa del manipulador Phantom X?
- Consulte en qué consiste el espacio diestro de un manipulador.

## ROS - Aplicación de Pick and place:
### Restricciones:
• Las trayectorias deberán ser tipo pick and place, esto es, recorridos en forma rectangular, movimientos verticales para subir y bajar, y movimiento horizontal para realizar desplazamientos.
  <p align="center"><img src="https://i.postimg.cc/Qdh7w27j/cinco.png"</p>
    
### Desarrollo de Script:
  Declaramos la cinemática directa del robots así como la conexión con el nodo maestro, la creación del cliente y el respectivo mensaje.
  
  
<p align="center"><img src="https://i.postimg.cc/3xNhVqyg/s1.png"</p>
  
  Establecemos las matrices de transformación homogéneas que definen las poses de los puntos de interés para la generación de la rutina pick and place, posteriormente, establecemos las diferentes trayectorias que unen los puntos de interés.

  <p align="center"><img src="https://i.postimg.cc/vBrw5Fjd/s2.png"</p>
    
    Posteriormente definimos las rutinas para la implementación del movimiento de cada trayectoria, para lo cual, se cuenta con las funciones move_tray_n y move_tray_2n.
    
    <p align="center"><img src="https://i.postimg.cc/wjrzpkJn/s3.png"</p>
      
      Finalmente las funciones move_tray_n y move_tray_2n, nos permiteninvocar los servicios y enviar los mensajes, para ejecutar las trayectorias definidas arribas en tiempo real.
      
      <p align="center"><img src="https://i.postimg.cc/NMqwyfd4/s4.png"</p>
        
      <p align="center"><img src="https://i.postimg.cc/mrFs2Fyk/s5.png"</p>
          
 

## ROS - Aplicación de movimiento en el espacio de la tarea:
## Conclusiones
