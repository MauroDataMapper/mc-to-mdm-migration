# Stage 1 : Metadata Catalogue Database Extraction

Because PostgreSQL does not allow cross-database queries we need to extract the
database and load into the new Mauro Data Mapper database.

## 1. Extract the Database

There are 2 main options here depending on how the Metadata Catalogue is currently running.

### MC-Docker Based PostgreSQL

If you run Metadata Catalogue using mc-docker then follow these instructions

1. Identify the name of the postgres container using command line
```bash
docker ps
```
1. Execute the following command whilst inside the `mc-to-mdm-migration/mc-extraction` directory
* The basic setup will result in the name `mc-docker_postgres_1`.
```bash
cd mc-to-mdm-migration/mc-extraction
docker exec -it mc-docker_postgres_1 pg_dump -F p -U postgres catalogue > output/mc-dump.sql
```

### Remote/Local PostgreSQL

If you have PostgreSQL running locally or on an external server then follow these instructions
*If you have renamed your database to something other than `catalogue` please update the name in the below.*


1. Make sure you have the PostgreSQL commands installed on your path
1. Execute the following command whilst inside the `mc-to-mdm-migration/mc-extraction` directory
```bash
cd mc-to-mdm-migration/mc-extraction
pg_dump -F p -U postgres catalogue > output/mc-dump.sql
```

#### Mac OS X PostgreSQL Commands

If using the [Postgres.app](https://postgresapp.com) follow the below to add the commands to the path.

```bash
sudo mkdir -p /etc/paths.d &&
echo /Applications/Postgres.app/Contents/Versions/latest/bin | sudo tee /etc/paths.d/postgresapp
```

## 2. Prepare the SQL dump to be loaded into the Mauro Data Mapper database

We need to repoint all the tables to a (temporary) schema for the migration.

*At the end of migration you can choose to keep or delete this schema*

```bash
cd mc-to-mdm-migration/mc-extraction
sed 's/public\./metadatacatalogue\./g' output/mc-dump.sql | \
sed 's/CREATE SCHEMA public;/CREATE SCHEMA metadatacatalogue;/' | \
sed 's/ALTER SCHEMA public OWNER TO postgres;//' > output/mc-dump-to-load.sql
```
