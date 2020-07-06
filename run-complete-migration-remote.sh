#!/bin/bash

POSITIONAL=()
while [[ $# -gt 0 ]]
do
key="$1"

case $key in
    -c)
    MDM_DOCKER_CONTAINER="$2"
    shift # past argument
    shift # past value
    ;;
    -m)
    MC_DOCKER_CONTAINER="$2"
    shift # past argument
    shift # past value
    ;;
    -d)
    MDM_DATABASE="$2"
    shift # past argument
    shift # past value
    ;;
    -o)
    MC_DATABASE="$2"
    shift # past argument
    shift # past value
    ;;
    -p)
    MDM_PORT="$2"
    shift # past argument
    shift # past value
    ;;
    -h)
    MDM_HOST="$2"
    shift # past argument
    shift # past value
    ;;
    -q)
    MC_PORT="$2"
    shift # past argument
    shift # past value
    ;;
    -i)
    MC_HOST="$2"
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
  echo "Usage:: run-migration-docker.sh [--help] [-c MDM_CONTAINER_NAME] [-m MC_CONTAINER_NAME] [-d MDM_DATABASE]"
  echo
  echo "  -c MDM_CONTAINER_NAME  :  Optional argument to set the mdm docker container to"
  echo "                            execute the migration against."
  echo "  -m MC_CONTAINER_NAME   :  Optional argument to set the mc docker container to"
  echo "                            execute the migration against."
  echo "                            Default: mdm-docker_postgres_1"
  echo "  -d MDM_DATABASE        :  Optional argument to set the mdm database inside to"
  echo "                            the docker container execute the migration against."
  echo "  -o MC_DATABASE         :  Optional argument to set the mc database inside to"
  echo "                            the docker container execute the migration against."
  echo "                            Default: maurodatamapper"
  echo "  -h MDM_HOST            :  Optional argument to set the mdm database host"
  echo "                            Default: localhost"
  echo "  -p MDM_PORT            :  Optional argument to set the mdm database port"
  echo "                            Default: 5432"
  echo "  -i MC_HOST             :  Optional argument to set the mc database host"
  echo "                            Default: localhost"
  echo "  -q MC_PORT             :  Optional argument to set the mc database port"
  echo "                            Default: 5432"
  echo "  --help                 :  This help"
  echo
  exit 0
fi

##################

echo "Performing complete non-interactive migration"

if [ -n "$MDM_DOCKER_CONTAINER" ]
then
  echo "Using docker container $MDM_DOCKER_CONTAINER"
else
  MDM_DOCKER_CONTAINER='mdm-docker_postgres_1'
  echo "Using default docker container mdm-docker_postgres_1"
fi

if [ -n "$MC_DOCKER_CONTAINER" ]
then
  echo "Using docker container $MC_DOCKER_CONTAINER"
else
  MC_DOCKER_CONTAINER='mc-docker_postgres_1'
  echo "Using default docker container mc-docker_postgres_1"
fi

if [ -n "$MDM_DATABASE" ]
then
   echo "Using database: $MDM_DATABASE"
else
  MDM_DATABASE='maurodatamapper'
  echo "Using default database: maurodatamapper"
fi

if [ -n "$MC_DATABASE" ]
then
   echo "Using database: $MC_DATABASE"
else
  MC_DATABASE='catalogue'
  echo "Using default database: catalogue"
fi

MC_DB_ARGS="-U postgres"

if [ -n "$MC_HOST" ]
then
  MC_DB_ARGS="$DB_ARGS -h $MC_HOST"
fi

if [ -n "$MC_PORT" ]
then
  MC_DB_ARGS="$DB_ARGS -p $MC_PORT"
fi

MDM_DB_ARGS="-U postgres"

if [ -n "$MDM_HOST" ]
then
  MDM_DB_ARGS="$DB_ARGS -h $MDM_HOST"
fi

if [ -n "$MDM_PORT" ]
then
  MDM_DB_ARGS="$DB_ARGS -p $MDM_PORT"
fi

##################

echo

echo "<< Stage 1 >>"

echo "Extracting mc-dump.sql"
pushd mc-extraction

pg_dump -F p -n public $MC_DB_ARGS $MC_DATABASE > output/mc-dump.sql

echo "Preparing mc-dump.sql for loading into MDM"

sed 's/public\./metadatacatalogue\./g' output/mc-dump.sql | \
    sed 's/CREATE SCHEMA public;/CREATE SCHEMA metadatacatalogue;/' | \
    sed 's/ALTER SCHEMA public OWNER TO postgres;//' > output/mc-dump-to-load.sql

popd
echo

echo "<< Stage 2 >>"
echo "Loading mc-dump-to-load.sql"
pushd mc-extraction

cat output/mc-dump-to-load.sql | psql $MDM_DB_ARGS $MDM_DATABASE

popd
echo

echo "<< Stage 3>>"
echo "  Performing SQL migration"
pushd migration

./run-migration-docker.sh -d $MDM_DATABASE -c $MDM_DOCKER_CONTAINER -h $MDM_HOST -p $MDM_PORT

popd

echo "Complete"

#################
