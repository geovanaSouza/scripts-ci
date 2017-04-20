#!/bin/bash

DB_USER=$1
DB_PWD=$2
DB_HOST=$3
DB_SVC_NAME=$4
DP_PARAMETERS=$5


docker run --rm geovanasouza/oracle-client:12.1.0.2.1 impdp $DB_USER/$DB_PWD@$DB_HOST:1521/$DB_SVC_NAME ${DP_PARAMETERS}