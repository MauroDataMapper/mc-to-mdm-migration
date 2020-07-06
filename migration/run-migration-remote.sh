#!/bin/bash

POSITIONAL=()
while [[ $# -gt 0 ]]
do
  key="$1"

  case $key in
    -f|--folder)
    MIGRATION_FOLDER="$2"
    shift # past argument
    shift # past value
    ;;
    -d|--database)
    DATABASE="$2"
    shift # past argument
    shift # past value
    ;;
    -p|--port)
    PORT="$2"
    shift # past argument
    shift # past value
    ;;
    -h|--host)
    HOST="$2"
    shift # past argument
    shift # past value
    ;;
    --help)
    USAGE=true
    shift # past argument
    ;;
    *)    # unknown option
    POSITIONAL+=("$1") # save it in an array for later
    shift # past argument
    ;;
  esac
done
set -- "${POSITIONAL[@]}" # restore positional parameters

##################

if [ $USAGE ]
then
  echo "Usage:: run-migration-docker.sh [--help] [-f MIGRATION_FOLDER] [-d DATABASE] [-h HOST] [-p PORT]"
  echo
  echo "  -f MIGRATION_FOLDER    :  Optional argument to only run the defined migration"
  echo "                            folder against the docker container"
  echo "  -d DATABASE            :  Optional argument to set the database inside to"
  echo "                            the docker container execute the migration against."
  echo "                            Default: maurodatamapper"
  echo "  -h HOST                :  Optional argument to set the database host"
  echo "                            Default: localhost"
  echo "  -p PORT                :  Optional argument to set the database port"
  echo "                            Default: 5432"
  echo "  --help                 :  This help"
  echo
  exit 0
fi

##################

# Process the folder running each file in order into the docker container
function process_folder {
  echo "> Migrating $1"
  pushd $1

  for f in *.sql
  do
    echo ">> Running $f"
    echo "cat $f | psql $DB_ARGS $DATABASE"
  done
  popd
  echo
}

##################

if [ -n "$DATABASE" ]
then
  echo "Using database: $DATABASE"
else
  DATABASE='maurodatamapper'
  echo "Using default database: maurodatamapper"
fi

DB_ARGS="-U postgres"

if [ -n "$HOST" ]
then
  DB_ARGS="$DB_ARGS -h $HOST"
fi

if [ -n "$PORT" ]
then
  DB_ARGS="$DB_ARGS -p $PORT"
fi

##################

echo

cd sql

# Install required dependencies
echo "Installing dependencies"
echo "cat install.sql | psql $DB_ARGS $DATABASE"

echo

# If no migration folder supplied then run every folder
if [ -z "$MIGRATION_FOLDER" ]
then
  echo "Migrating ALL folders/schemas"
  echo
  for d in */
  do
    process_folder $d
  done
else
  echo "Migrating provided folder ONLY"
  echo
  # Otherwise just run the chosen folder
  process_folder $MIGRATION_FOLDER
fi

echo "Completed Migration"

#################
