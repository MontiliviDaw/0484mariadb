# Utilitzem una imatge base que ja inclou Apache i PHP per a phpMyAdmin
# La imatge 'phpmyadmin/phpmyadmin' és una bona base
FROM phpmyadmin/phpmyadmin:latest

# --- Configuració del Servidor de Base de Dades MariaDB ---

# Instal·lem el client i servidor MariaDB i altres utilitats essencials
RUN apt-get update && \
    apt-get install -y mariadb-client mariadb-server procps vim wget gettext && \
    rm -rf /var/lib/apt/lists/*

# Estableix la contrasenya de root de MariaDB. 
# Es recomana usar variables d'entorn en producció, però per l'institut podem definir-les aquí.
# també es poden modificar en la comanda docker run
ENV MARIADB_ROOT_PASSWORD="damDAW12"
ENV MARIADB_DATABASE="usuari"
ENV MARIADB_USER="usuari"
ENV MARIADB_PASSWORD="usuari"
# Opcional: Estableix la configuració del servidor de base de dades per a phpMyAdmin
ENV PMA_HOST="127.0.0.1"
ENV PMA_PORT=3306

# --- Inicialització de Bases de Dades ---

# Carpeta on posarem els scripts SQL.
# **Hem de crear una carpeta anomenada 'sql_init' al mateix directori que el Dockerfile**
WORKDIR /docker-entrypoint-initdb.d/

# Copia els scripts SQL que s'executaran a l'inici. 
# Els scripts han de ser a la carpeta 'sql_init' i acabar en .sql, .sh o .gz
COPY ./sql_init/ /docker-entrypoint-initdb.d/

# --- Punt d'Entrada (Entrypoint) ---

# Instal·lem un script d'inici per arrencar tant MariaDB com Apache/phpMyAdmin.
# Això és complex perquè la imatge base ja té el seu propi entrypoint per Apache.
# Per simplificar, farem un "wrapper" que llançarà tots dos serveis.

# Copia l'script d'inici personalitzat
COPY docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

# Usa el nou script com a punt d'entrada
ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]

# Exposa els ports
# Port 80 per a phpMyAdmin (web)
# Port 3306 per a MariaDB (DBeaver/client)
EXPOSE 80 3306

# Comandament per defecte (serà executat per l'ENTRYPOINT)
CMD ["apache2-foreground"]
