#!/bin/bash

DB_USER=$1
DB_PWD=$2
DB_HOST=$3
DB_SVC_NAME=$4
DP_DIR=$5
DP_FILE=$6

docker run --rm geovanasouza/jdk-orcl_oracleclient:7 impdp $DB_USER/$DB_PWD@$DB_HOST:1521/$DB_SVC_NAME DIRECTORY=${DP_DIR} DUMPFILE=${DP_FILE}