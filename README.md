# minihs-scanner-TS7970

Este proyecto tiene como objetivo facilitar el proceso de compilación del proyecto minihs-scanner para el TS-7970 utilizando emulación de un entorno armhf mediante Docker y QEMU.

## Dependencies

```bash
sudo apt-get install qemu-user-static
```

## Instrucciones de compilación

Para compilar el proyecto, sigue estos pasos:

### Clonar el repositorio:
```bash
git clone https://  --recursive
cd minihs-scanner
```

### Compilar el proyecto:

Ejecuta el comando make all para iniciar el proceso de compilación.

```bash
make all
```

Este comando ejecutará varios pasos de compilación definidos en el archivo Makefile.

## Targets del Makefile

El archivo Makefile define varios targets que automatizan el proceso de compilación y empaquetado del proyecto. A continuación se explican cada uno de ellos:

* **docker:**
    Este target construye un contenedor Docker con soporte para emulación de arquitectura armhf. Utiliza la imagen multiarch/qemu-user-static para configurar QEMU y luego construye una imagen llamada armhf-bullseye-toolchain que servirá para compilar el proyecto en un entorno armhf emulado.

* **compilation:**
    El target compilation depende del target docker y de todos los archivos del proyecto ($(PROJECT_FILES)). Utiliza el contenedor Docker creado en el paso anterior para ejecutar el script fast_build.sh, que realiza la compilación del proyecto minihs-scanner dentro del contenedor.

* **full_build_package:**
    Después de completar la compilación (compilation), este target empaqueta todo el resultado de la compilación en un archivo fullbuild.zip. El contenido de este archivo incluye todos los archivos generados durante la compilación en el directorio build_fast.

* **src_build_package:**
    Similar a full_build_package, pero este target crea un archivo srcbuild.zip que contiene únicamente los archivos generados en la compilación de las fuentes del proyecto, ubicados en el directorio build_fast/src.

* **binary_build_package:**
    Finalmente, este target crea un archivo binbuild.zip que contiene solo los binarios compilados del proyecto, específicamente los ejecutables cameraServer, controller, y motorServer, ubicados en build_fast/src.




sudo apt-get install qemu-user-static

sudo docker run --rm --privileged multiarch/qemu-user-static --reset -p yes

sudo docker build --tag armhf-bullseye-toolchain .
