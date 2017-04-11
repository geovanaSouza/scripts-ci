#!/bin/bash

#Maven Options:
#  To execute build:
#  PreReq:
#    * File .maven-ci.json with syntax: { "build": [ { "project": "xyz", "task": "clean install xyz" }, { "project": "xyz", "task": "clean install xyz" } ] }'
#    ./maven-docker.sh build'
###
#  To set version:'
#  PreReq:'
#    * File .maven-ci.json with syntax: { "version": [ { "project": "xyz" }, { "project": "xyz" } ] }'
#    * Environment Variable: PROJECT_VERSION'
#  ./maven-docker.sh version'
###
#  To build dist package:'
#  PreReq:'
#    * File .maven-ci.json with syntax: { "dist": [ { "project": "xyz" }, { "project": "xyz" } ] }'
#  ./maven-docker.sh dist'

ACTION=$1

#docker_stop(){
#  CONTAINER_NAME=$1
#  CONTAINER_FIND=$(docker ps -a --filter "name=${CONTAINER_NAME}" | tail -n+2 | wc -l)

#  if [[ "$CONTAINER_FIND" == '1' ]]; then
#    docker stop ${CONTAINER_NAME}
#    docker rm ${CONTAINER_NAME}
#  fi
#}

mvn_execute(){
  PROJECT_NAME=$1
  MVN_ARGS=$(echo $2 | envsubst)
  #CONTAINER_NAME=$(echo ${JOB_NAME}_${PROJECT_NAME} | tr "\")
  
  : "${CONFIG_APPLICATION:?Need to set CONFIG_APPLICATION non-empty}"

  echo PROJECT_NAME=${PROJECT_NAME}
  echo MVN_ARGS=${MVN_ARGS}

  cd $WORKSPACE/src/
  #docker_stop ${CONTAINER_NAME}
  
  docker run --rm  -v "$PWD":/usr/src/mymaven -v "$WORKSPACE/scripts/.bowerrc":/root/.bowerrc -v "$WORKSPACE/scripts/$CONFIG_APPLICATION/maven-settings.xml":/usr/share/maven/ref/settings.xml -v "$JENKINS_HOME/.m2/repository":/usr/share/maven/repository -w /usr/src/mymaven maven:3-jdk-7 /bin/bash -c "cd ${PROJECTS_DIR}/${PROJECT_NAME}; mvn ${MVN_ARGS}"
#--name ${CONTAINER_NAME}
}


PROJECT_COUNT=$(jq ".$ACTION | length" $WORKSPACE/src/.maven-ci.json)

for (( key=0; key<${PROJECT_COUNT}; key++ ))
do  
  PROJECT_NAME=$(jq ".$ACTION[$key].project" $WORKSPACE/src/.maven-ci.json | tr -d '"')
  MVN_ARGS=$(jq ".$ACTION[$key].task" $WORKSPACE/src/.maven-ci.json | tr -d '"')
  mvn_execute $PROJECT_NAME "${MVN_ARGS}"
done
