#!/bin/bash

# This script builds a JSON from a YAML source
#
# Variables: 
#  - WORKFLOW: file name of the workflow to publish
#  - ENVIRONMENT: environment where to deploy (staging, production...)

set -eux 

CURRENT_DIR="$(pwd)"
WF_FILE="$(find ${CURRENT_DIR} -name ${WORKFLOW_SRC})"

echo ${WF_FILE}

sed -i s#ENVIRONMENT#${ENVIRONMENT}#g "${WF_FILE}"

wfcli parse "${WF_FILE}"

JSON_FILE=$( echo ${WF_FILE} | rev | cut -f2- -d'.' | rev).json

mv "${JSON_FILE}" ${CURRENT_DIR}/built-artifacts/
