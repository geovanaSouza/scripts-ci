#!/bin/bash

DB_USER=$1
DB_PWD=$2
DB_HOST=$3
DB_SVC_NAME=$4
SCRIPT_NAME=$5

docker run --rm -v "$PWD/scripts":/tmp/scripts geovanasouza/jdk-orcl_instantclient:7 sqlplus -s  $DB_USER/$DB_PWD@$DB_HOST:1521/$DB_SVC_NAME @/tmp/scripts/$SCRIPT_NAME