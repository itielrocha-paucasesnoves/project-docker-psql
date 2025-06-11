#Imagen del sistema a usar:
FROM ubuntu:22.04

#Evitar mensajes interactivos del sistema
ENV DEBIAN_FRONTEND=noninteractive

#Actualizar listado de paquetes en sus repositorios
RUN apt update

#Instalar herramientas necesarias para añadir el repositorio
RUN apt install -y wget gnupg

#Añadir el repositorio con la siguiente url con mi versión y crear un archivo en la siguiente ruta con la línea dentro
RUN echo "deb http://apt.postgresql.org/pub/repos/apt jammy-pgdg main" > /etc/apt/sources.list.d/PostgreSQLrepo.list

#Añadir clave pública a la lista de apt-key
RUN wget -q -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -

#Actualizar repositorios otra vez para detectar el de PostgreSQL
RUN apt update

#Instalar PostgreSQL 14
RUN apt install -y postgresql-14

#Crear directorio de databases
RUN mkdir /home/databases

#Cambiar de propiedad el directorio de databases
RUN chown -R postgres:postgres /home/databases

#Establecer contraseña de usuario postres
ENV POSTGRES_DEFAULT_PASS=4dm1n!

#Exponer puerto del contenedor
EXPOSE 5432

#Cambiar de usuario para iniciar PostgreSQL
USER postgres

#Inicializar directorio de databases
RUN /usr/lib/postgresql/14/bin/initdb -D /home/databases

#Importar archivo de configuración "#Josepmaribelike"
COPY postgresql.conf /home/databases

#Cambiar directorio
WORKDIR /tmp

#Descargar esquema y datos SAKILA
RUN wget https://raw.githubusercontent.com/jOOQ/sakila/refs/heads/main/postgres-sakila-db/postgres-sakila-schema.sql
RUN wget https://raw.githubusercontent.com/jOOQ/sakila/refs/heads/main/postgres-sakila-db/postgres-sakila-insert-data.sql

#Ejecutar consola postgresql en carpeta databases
RUN /usr/lib/postgresql/14/bin/pg_ctl -D /home/databases start && \
#
    #Cambiar contraseña del usuario postgres con variable de entorno
    psql -c "ALTER USER postgres WITH PASSWORD '$POSTGRES_DEFAULT_PASS';" && \
#
    #Crear database
    psql -c "CREATE DATABASE sakila;" && \
#
    #Importar esquema y datos de SAKILA
    psql -d sakila -f /tmp/postgres-sakila-schema.sql && \
    psql -d sakila -f /tmp/postgres-sakila-insert-data.sql && \
#
    #Crear usuario requerido y darle permisos
    psql -c "CREATE USER \"sakila-user\" WITH PASSWORD 'U\$er?';" && \
    psql -c "GRANT ALL PRIVILEGES ON DATABASE sakila TO \"sakila-user\";"

#Importar archivo de conexiones "#Josepmaribelike"
COPY pg_hba.conf /etc/postgresql/14/main

#Ejecución de proceso
CMD ["/usr/lib/postgresql/14/bin/postgres", "-D", "/home/databases", "-c", "config_file=/home/databases/postgresql.conf"]