#!/bin/bash

PACKAGE_DIR=$1
INSTALLER_ARGS=$2

docker run --rm -v "${PACKAGE_DIR}":/usr/src/myapp -v $WORKSPACE/scripts:/usr/src/scripts -w /usr/src/myapp geovanasouza/jdk-orcl_instantclient:7 ../scripts/${CONFIG_APPLICATION}/installer-no-interactive.exp ${INSTALLER_ARGS}