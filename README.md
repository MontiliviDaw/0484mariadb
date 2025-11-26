# Construcció i execució del contenidor

Si no volem configurar res especiual i volem treballar directament amb aquest repositori cal seguir les següents comandes:

```bash title="Creació de la imatge"
docker build -t damdaw-db-i:latest .
```

```bash title="Execució del contenidor la primera vegada"
docker run -d --name damdaw-db -p 8080:80 -p 3307:3306 damdaw-db-i:latest
```

Hem obert els ports

* Accés **web** pel port `8080`

* Accés al **servidor de bases de dades** pel port `3307`

A partir d'aquí, sempre que es vulgui treballar amb el servidor de bases de dades, haurem d'executar la comanda `docker start`

```bash title="Execució del contenidor a partir de la segona vegada"
docker start damdaw-db
```

Per aturar el contenidor

```bash title="Aturem el contenidor"
docker stop damdaw-db
```

Per accedir a la base de dades

* des del *phpmyadmin* ho farem a partir de l'enllaç següent:

    [http://localhost:8080/](http://localhost:8080/)

* des de la consola xecutant la comanda

    ```bash
    docker exec -ti damdaw-db mysql -u usuari -pusuari
    ```


# Com Construir i Executar

Creeu els fitxers: Assegureu-vos de tenir:

* el fitxer `Dockerfile`,

* la carpeta `sql_init` (amb els vostres fitxers SQL) 

* el fitxer `docker-entrypoint.sh`

al mateix directori.

Opcionalment podem 

* afegir el fitxer `sql_init/zz-custom-settings.cnf` per personalitzar el servidor de bases de dades.

## Construïu la imatge:

En l'exemple es crea una imatge anomenada `damdaw-db-i`

```bash
docker build -t damdaw-db-i:latest .
```

# Executeu el contenidor:

En l'exemple es crea un contenidor anomenat `damdaw-db` a partir de la imatge `damdaw-db-i`

```bash
docker run -d --name damdaw-db -p 8080:80 -p 3307:3306 damdaw-db-i:latest
```

* S'exposa el port web a `8080` de la màquina host.

* S'exposa el port de MariaDB a `3307` de la màquina host.

En cas necessari podem executar el contenidor modificant els paràmetres del Dockerfile:

* `MARIADB_ROOT_PASSWORD`="damDAW12"

    Password per l'usuari `root`

* `MARIADB_USER`="usuari"

    Usuari que es crea per accedir a la base de dades i a totes les diferents bases de dades

* `MARIADB_PASSWORD`="usuari"
    
    Serà el password de l'usuari que es crea

* `MARIADB_DATABASE`="usuari"

    Base de dades que es crea la primera vegada i que si existeix, no executa els scripts sql

* `PMA_HOST`="127.0.0.1"

    Estableix la configuració del servidor de base de dades per a phpMyAdmin

* `PMA_PORT`=3306

    Estableix la configuració del servidor de base de dades per a phpMyAdmin

## Accés client

* phpMyAdmin (Navegador): http://localhost:8080 (o la IP del servidor).

    * Servidor: 127.0.0.1 o localhost (dins del contenidor, que és on phpMyAdmin es connecta)
    
    * Usuari: `<MARIADB_USER>`
    
    * Contrasenya: `<MARIADB_PASSWORD>`

* DBeaver (Eina Client Visual):

    * Host: `127.0.0.1`

    * Port: **`3307`**

    * Base de Dades: `<MARIADB_DATABASE>` o deixeu-ho en blanc

    * Usuari: `<MARIADB_USER>`

    * Contrasenya: `<MARIADB_PASSWORD>`

* CMD o PowerShell o Shell:

    * `docker exec -ti damdaw-db mysql -u <MARIADB_USER> -p<MARIADB_PASSWORD> <MARIADB_DATABASE>`

## Paràmetres del my.ini

S'han configurat diferents paràmetres, per defecte, per poder treballar:

* `sql_mode=NO_ZERO_IN_DATE,NO_ZERO_DATE,NO_ENGINE_SUBSTITUTION,ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES`

    No permet executar el `GROUP BY` de forma *"incorrecta"*

* `lower_case_table_names=1`

    Permet fer les consultes amb els noms de les taules en majúscules i trobar-les sempre ja que les emmagatzema sempre enminúscules i en fa la transformació. És el que sol fer-se en Windows. _**No sol ser el paràmetre per defecte en Linux**_.

* `bind-address = 0.0.0.0`

    Permet accedir directament desde qualsevol IP, ens va béper accedir a través de les eines client com ara *DBeaver*.

## Paràmetres opcionals

La comanda `envsubst` (Environment Variable Substitution) és la manera estàndard i neta de fer substitucions de variables d'entorn en fitxers de configuració. S'ha instal·lat a la secció `RUN` del `Dockerfile` (part del paquet `gettext`).

### Ús i Execució

Un cop hagis reconstruït la teva imatge (`docker build -t la_meva_imatge .`), pots iniciar el contenidor i sobreescriure el valor per defecte de la variable d'entorn:

* Ús amb el valor per defecte:

    ```bash
    docker run -d -p 8080:80 -p 3307:3306 --name el_meu_contenidor la_meva_imatge
    ```

* Ús amb un valor modificat:

    ```bash
    docker run -d -p 8080:80 -p 3307:3306 -e MARIADB_USER=pepet --name el_meu_contenidor_custom la_meva_imatge
    ```
