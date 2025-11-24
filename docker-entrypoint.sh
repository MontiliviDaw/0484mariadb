#!/bin/bash
set -e

# --- 1. Inici de MariaDB ---

# Comprovem que està instal·lat
if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "Falta el servidor de base de dades ..."
    exit 1
fi
 
# Si volem modificar algun dels paràmetres del fitxer my.ini els  paràmetres en el fitxer del repositori
# sql_init/zz-custom-settings.cnf i els copiarem a /etc/mysql/mariadb.conf.d del contenidor

## Modifiquem la forma de treballar del servidor
if [ -f "/docker-entrypoint-initdb.d/zz-custom-settings.cnf" ]; then
    cp /docker-entrypoint-initdb.d/zz-custom-settings.cnf /etc/mysql/mariadb.conf.d/
fi

# Inicia MariaDB en segon pla
echo "Iniciant MariaDB..."
/usr/bin/mariadbd-safe --user=mysql &
PID_MARIADB=$!

# Esperem que MariaDB estigui disponible
timeout=30
while ! mysqladmin ping -h 127.0.0.1 --silent; do
    echo "   Provant ... $timeout"
    timeout=$((timeout - 1))
    if [ $timeout -eq 0 ]; then
        echo "Error: MariaDB no s'ha iniciat a temps."
        exit 2
    fi
    sleep 1
done
echo "MariaDB està llest."
 
# --- 2. Configuració de l'Usuari/BD i Execució de Scripts SQL ---

# Només executa la configuració i els scripts si la base de dades no existeix
if ! mysql -u root -p"$MARIADB_ROOT_PASSWORD" -e "USE $MARIADB_DATABASE"; then

    # Password del root
    mysql -u root -p"$MARIADB_ROOT_PASSWORD" -e "alter user root@localhost identified by '$MARIADB_ROOT_PASSWORD';"
    
    # Creem l'usuari i la base de dades
    mysql -u root -p"$MARIADB_ROOT_PASSWORD" -e "CREATE DATABASE IF NOT EXISTS $MARIADB_DATABASE;"
    mysql -u root -p"$MARIADB_ROOT_PASSWORD" -e "CREATE USER IF NOT EXISTS '$MARIADB_USER'@'%' IDENTIFIED BY '$MARIADB_PASSWORD';"
    mysql -u root -p"$MARIADB_ROOT_PASSWORD" -e "GRANT ALL PRIVILEGES ON $MARIADB_DATABASE.* TO '$MARIADB_USER'@'%' WITH GRANT OPTION;"
    mysql -u root -p"$MARIADB_ROOT_PASSWORD" -e "GRANT ALL PRIVILEGES ON $MARIADB_DATABASE.* TO '$MARIADB_USER'@'%' WITH GRANT OPTION;"
    mysql -u root -p"$MARIADB_ROOT_PASSWORD" -e "FLUSH PRIVILEGES;"
    
    echo "Configuració de BD completada. Executant scripts SQL inicials..."

    # Executem els scripts SQL de la carpeta initdb amb els possibles paràmetres d'entorn
    for f in /docker-entrypoint-initdb.d/*; do
        case "$f" in
            *.sql)  echo "$0: running $f"
                    envsubst < "$f" > "$f.env"
                    mysql -u root -p"$MARIADB_ROOT_PASSWORD" $MARIADB_DATABASE  < "$f.env"
                    rm "$f.env"
                    ;;
            *.sh)   echo "$0: running $f"; "$f" ;;
            *)      echo "$0: ignoring $f" ;;
        esac
    done
fi

# Fitxer que potser falta al phpmyadmin
if [ ! -f "/etc/phpmyadmin/config.secret.inc.php" ]; then
    echo "Creem el fitxer /etc/phpmyadmin/config.secret.inc.php"
    touch /etc/phpmyadmin/config.secret.inc.php
    chown www-data: /etc/phpmyadmin/config.secret.inc.php
 fi

# --- 3. Inici de phpMyAdmin/Apache (Entrypoint Original) ---

echo "Iniciant phpMyAdmin (Apache)..."
# Executa la comanda passada a l'ENTRYPOINT (CMD)
exec "$@"

# Amb 'exec' el PID 1 del shell és substituït per l'Apache, assegurant una gestió correcta de senyals