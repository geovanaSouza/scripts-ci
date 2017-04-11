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

  cd $WORKSPACE/src/${PROJECTS_DIR}
  mvn ${MVN_ARGS}
  cd $WORKSPACE
}


PROJECT_COUNT=$(jq ".$ACTION | length" $WORKSPACE/src/.maven-ci.json)

for (( key=0; key<${PROJECT_COUNT}; key++ ))
do
  PROJECT_NAME=$(jq ".$ACTION[$key].project" $WORKSPACE/src/.maven-ci.json | tr -d '"')
  MVN_ARGS=$(jq ".$ACTION[$key].task" $WORKSPACE/src/.maven-ci.json | tr -d '"')
  mvn_execute $PROJECT_NAME "${MVN_ARGS}"
done
