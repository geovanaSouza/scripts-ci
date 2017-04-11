#!/bin/bash

export FILE=$1
export CONTENT_LINE=$(echo $2 | tr -d '"')
export SUFFIX=$3

sed -i "s/${SUFFIX}${CONTENT_LINE}/${CONTENT_LINE}/" $FILE

