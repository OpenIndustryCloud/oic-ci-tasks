#!/bin/bash

# This script builds a JSON from a YAML source
#
# Variables: 
#  - WORKFLOW: file name of the workflow to publish
#  - ENVIRONMENT: environment where to deploy (staging, production...)

set -eux 

CURRENT_DIR="$(pwd)"
WF_FILE="$(find . -name ${WORKFLOW_SRC})"

sed -i s#ENVIRONMENT#${ENVIRONMENT}#g "${WF_FILE}"

wfcli parse "${WF_FILE}" | tail -n1 | xargs -I {} mv {} ${CURRENT_DIR}/built-artifacts/
