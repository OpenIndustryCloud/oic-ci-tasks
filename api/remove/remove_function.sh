#!/bin/bash

# This script deploys a Fission Function in a cluster for CI analysis
#
# Variables: 
#  - ENVIRONMENT: dev, staging, production... Will result in prefixing the URL by its content
#  - FUNCTION_NAME: name of the function to deploy. 
#  - FUNCTION_ENVIRONMENT: name of the environment of the function: go, python, nodejs or binary
#  - CODE_PATH: where to find the code of the function
#  - FUNCTION_METHOD: GET, POST, DELETE or any other specific method needed

set -eux 

fission function delete --name ${ENVIRONMENT}-${FUNCTION_NAME} || true

fission route list | \
	grep "${ENVIRONMENT}-${FUNCTION_NAME}" | \
	grep ${FUNCTION_METHOD} | \
	grep "/${ENVIRONMENT}/${FUNCTION_NAME}" | \
	awk '{ print $1 }' | \
	xargs fission route delete --name 