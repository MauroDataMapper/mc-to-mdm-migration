# Stage 2 : Load Metadata Catalogue database into Mauro Data Mapper Database

We expect all variants of Mauro Data Mapper to be running inside Docker however we will provide the steps for both Docker and Remote/Local PostgreSQL
servers.

The following steps assume you have
* Completed stage 1 and the files are in the location and named according to that guide
* Done one of the following
  * Started `mdm-docker`
  * Created a `maurodatamapper` database

## MDM-Docker Based PostgreSQL

If you run Mauro Data Mapper using mc-docker then follow these instructions

1. Identify the name of the postgres container using command line
```bash
docker ps
```
1. Execute the following command whilst inside the `mc-to-mdm-migration/mc-extraction` directory
* The basic setup will result in the name `mdm-docker_postgres_1`.
```bash
cd mc-to-mdm-migration/mc-extraction
cat output/mc-dump-to-load.sql | docker exec -i mdm-docker_postgres_1 psql -U postgres maurodatamapper
```

## Remote/Local PostgreSQL

If you have PostgreSQL running locally or on an external server then follow these instructions
*If you have renamed your database to something other than `maurodatamapper` please update the name in the below.*

1. Execute the following command whilst inside the `mc-to-mdm-migration/mc-extraction` directory
```bash
cd mc-to-mdm-migration/mc-extraction
cat output/mc-dump-to-load.sql | psql -U postgres maurodatamapper
```

## Tidy Up / Backup

You can choose to delete or keep/backup the `mc-to-mdm-migration/mc-extraction/output/mc-dump.sql` file.
This file is a full dump of the entire DDL and data from your Metadata Catalogue instance and can be used to restore a fully running
Metadata Catalogue server if you ever need.

After this point you will not need the file again in this migration process.
