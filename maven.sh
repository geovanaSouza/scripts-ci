#!/bin/bash

#Maven Options:
#  To execute build:
#  PreReq:
#    * File .maven-ci.json with syntax: { "build": [ { "project": "xyz", "task": "clean install xyz" }, { "project": "xyz", "task": "clean install xyz" } ] }'
#    ./maven.sh build'
###
#  To set version:'
#  PreReq:'
#    * File .maven-ci.json with syntax: { "version": [ { "project": "xyz" }, { "project": "xyz" } ] }'
#    * Environment Variable: PROJECT_VERSION'
#  ./maven.sh version'
###
#  To build dist package:'
#  PreReq:'
#    * File .maven-ci.json with syntax: { "dist": [ { "project": "xyz" }, { "project": "xyz" } ] }'
#  ./maven.sh dist'

ACTION=$1

mvn_execute(){
  PROJECT_NAME=$1
  MVN_ARGS=$(echo $2 | envsubst)

  : "${CONFIG_APPLICATION:?Need to set CONFIG_APPLICATION non-empty}"

  echo PROJECT_NAME=${PROJECT_NAME}
  echo MVN_ARGS=${MVN_ARGS}

  cd ${PROJECTS_DIR}/${PROJECT_NAME}

  if [[ "$MVN_ARGS" == 'manual_replace' ]]; then
    xmlstarlet edit -L -N pom=http://maven.apache.org/POM/4.0.0 -u '/pom:project/pom:parent/pom:version' -v "${PROJECT_VERSION}" pom.xml
  else
    mvn ${MVN_ARGS}
  fi
  cd $WORKSPACE
}


PROJECT_COUNT=$(jq ".$ACTION | length" $WORKSPACE/.maven-ci.json)

for (( key=0; key<${PROJECT_COUNT}; key++ ))
do
  PROJECT_NAME=$(jq ".$ACTION[$key].project" $WORKSPACE/.maven-ci.json | tr -d '"')
  MVN_ARGS=$(jq ".$ACTION[$key].task" $WORKSPACE/.maven-ci.json | tr -d '"')
  mvn_execute $PROJECT_NAME "${MVN_ARGS}"
done
#
#
#
#
#
