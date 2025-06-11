# CHEATSHEET-DOCKER

## Cambios default configuración

### postgresql.conf:

-  `listen_address = '*'`
- `data_directory = '/home/databases'`
- comentado: `include_dir = "conf.d"`

### pg_hba.conf:

- Cambiado método de autenticación de peer a md5 en local y en remoto.
- Permitimos solo conexión en remoto a la base de datos sakila.
- Cambiamos la dirección por la que escucha con `host` a `0.0.0.0/0` y `::/0`

## Comandos de ejecución

- Construcción de imagen:
  ``` bash
  docker build -t postgresql-14-asix .
  ```
- Creación del contenedor a partir de imagen
  ``` bash
  docker run -d --name postgresql-14-asix -p 2345:5432 postgresql-14-asix
  ```
- Revisión de logs
  ``` bash
  docker logs -f postgresql-14-asix
  ```
- Apago de contendor
  ``` bash
  docker stop postgresql-14-asix
  ```
- Eliminación de contenedor
  ``` bash
  docker rm postgresql-14-asix
  ```
- Listar contenedores
  ``` bash
  docker ps -a
  ```
- Listar imágenes
  ``` bash
  docker image ls
  ```
## Explicación de argumentos

`-d` Desacoplar del primer plano
`-

