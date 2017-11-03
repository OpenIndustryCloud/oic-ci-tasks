#!/bin/bash

# This script deploys a Fission Function in a cluster for CI analysis
#
# Variables: 
#  - FUNCTION_NAME: name of the function to deploy. 
#  - FUNCTION_ENVIRONMENT: name of the environment of the function: go, python, nodejs or binary
#  - CODE_PATH: where to find the code of the function

set -eux 

DIR="$(echo ${CODE_PATH} | rev | cut -f2- -d'/' | rev)"
FUNCTION="$(echo ${CODE_PATH} | rev | cut -f1 -d'/' | rev)"

cd "${DIR}"

go build -buildmode=plugin \
  -o /built-artifacts/${FUNCTION_NAME}.so \
  "${FUNCTION}"

