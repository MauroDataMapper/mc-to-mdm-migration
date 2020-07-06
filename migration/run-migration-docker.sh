#!/bin/bash

POSITIONAL=()
while [[ $# -gt 0 ]]
do
  key="$1"

  case $key in
    -c|--docker-container)
    DOCKER_CONTAINER="$2"
    shift # past argument
    shift # past value
    ;;
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

# Process the folder running each file in order into the docker container
function process_folder {
  echo "> Migrating $1"
  pushd $1

  for f in *.sql
  do
    echo ">> Running $f"
    cat $f | docker exec -i $DOCKER_CONTAINER psql -U postgres $DATABASE
  done
  popd
  echo
}

##################

if [ $USAGE ]
then
  echo "Usage:: run-migration-docker.sh [--help] [-c CONTAINER_NAME] [-f MIGRATION_FOLDER] [-d DATABASE]"
  echo
  echo "  -c CONTAINER_NAME      :  Optional argument to set the docker container to"
  echo "                            execute the migration against."
  echo "                            Default: mdm-docker_postgres_1"
  echo "  -f MIGRATION_FOLDER    :  Optional argument to only run the defined migration"
  echo "                            folder against the docker container"
  echo "  -d DATABASE            :  Optional argument to set the database inside to"
  echo "                            the docker container execute the migration against."
  echo "                            Default: maurodatamapper"
  echo "  --help                 :  This help"
  echo
  exit 0
fi

##################

if [ -n "$DOCKER_CONTAINER" ]
then
  echo "Using docker container $DOCKER_CONTAINER"
else
  DOCKER_CONTAINER='mdm-docker_postgres_1'
  echo "Using default docker container mdm-docker_postgres_1"
fi

if [ -n "$DATABASE" ]
then
  echo "Using database: $DATABASE"
else
  DATABASE='maurodatamapper'
  echo "Using default database: maurodatamapper"
fi

##################

echo

cd sql

# Install required dependencies
echo "Installing dependencies"
cat install.sql | docker exec -i $DOCKER_CONTAINER psql -U postgres $DATABASE

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
