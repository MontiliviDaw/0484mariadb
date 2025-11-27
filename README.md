# Servidor de Bases de dades MariaDB i phpMyAdmin

Aquest repositori, mitjançant *Docker*, crea un contenidor amb un servidor de Bases de Dades *MariaDB* amb accés web amb l'eina *phpmyadmin* instal·lada al mateix contenidor.

Exportem el port del servidor de base de dades (*`3306`*) i el del servidor web (*`80`*) per poder accedir a la base de dades des d'un navegador o des de qualsevol aplicació client. En l'exemple, es mapegen sobre els ports *`3307`* i *`8080`* respectivament per no interferir en altres servidors que tinguem iniciats.

També ens permet afegir scripts `.sql` i `.sh` per crear les nostres bases de dades inicials o per altres tasques pertinents.

# Construcció i execució del contenidor

Si no volem configurar res especial i volem treballar directament amb aquest repositori cal seguir les següents comandes:

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

* des de la consola executant la comanda

    ```bash
    docker exec -ti damdaw-db mysql -u usuari -pusuari
    ```

# Com Construir i Executar

Creeu els fitxers: Assegureu-vos de tenir:

* el fitxer `Dockerfile`,

* la carpeta `sql_init` (amb els vostres fitxers `.sql` i `.sh`) 

* el fitxer `docker-entrypoint.sh`

al mateix directori.

Opcionalment podem 

* afegir el fitxer `sql_init/zz-custom-settings.cnf` per personalitzar el servidor de bases de dades.

## Construïu la imatge:

En l'exemple es crea una imatge anomenada `damdaw-db-i`

```bash
docker build -t damdaw-db-i:latest .
```

## Executeu el contenidor:

En l'exemple es crea un contenidor anomenat `damdaw-db` a partir de la imatge `damdaw-db-i`

```bash
docker run -d --name damdaw-db -p 8080:80 -p 3307:3306 damdaw-db-i:latest
```

* S'exposa el port web al `8080` de la màquina host.

* S'exposa el port de MariaDB al `3307` de la màquina host.

En cas necessari podem executar el contenidor modificant els paràmetres del Dockerfile o bé passant els nous valors en el moment de la creació del contenidor:

* `MARIADB_ROOT_PASSWORD`="damDAW12"

    Password per l'usuari `root`

* `MARIADB_USER`="usuari"

    Usuari que es crea per accedir a la base de dades i a totes les diferents bases de dades

* `MARIADB_PASSWORD`="usuari"
    
    Password de l'usuari que es crea

* `MARIADB_DATABASE`="usuari"

    Base de dades que es crea la primera vegada i que si existeix en iniciar el contenidor, no executa els scripts sql. Això ens permet no haver de recrear cada dia el contenidor sinó mantenir la consistència de la base de dades.

* `PMA_HOST`="127.0.0.1"

    Estableix la configuració del servidor de base de dades per a phpMyAdmin

* `PMA_PORT`=3306

    Estableix la configuració del servidor de base de dades per a phpMyAdmin

Exemple de creació del contenidor amb altres paràmetres:

```bash
docker run -d --name damdaw-db -e MARIADB_ROOT_PASSWORD=123456 -e MARIADB_USER=uuuu -e MARIADB_PASSWORD=aaaa -p 8080:80 -p 3307:3306 damdaw-db-i:latest
```

En aquest contenidor tenim un usuari de consulta anomenat `uuuu` i la seva clau d'accés és `aaaa`. A més el password del DBA (*root*) és `123456` per tant podriem entrar a la consola *mysql* de la següent forma:

```bash
docker exec -ti damdaw-db mysql -u root -p123456
```

# Atureu el contenidor i torneu a iniciar

Per aturar el contenidor podem utilitzar la comanda

```bash
docker stop damdaw-db
```

Una vegada aturat el contenidor, podem tornar a iniciar-lo executant la següent comanda des de qualsevol directori

```bash
docker start damdaw-db
```

El contenidor s'iniciarà amb els mateixos paràmetres amb què es va crear i les mateixes dades amb què es va aturar.

# Accés client

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

    Permet accedir directament des de qualsevol IP, ens va bé per accedir a través de les eines client com ara *DBeaver*.


