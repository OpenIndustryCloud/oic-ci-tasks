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

case "${FUNCTION_ENVIRONMENT}" in 
	"go" )
		CODE_ARG="--deploy"
	;;
	* )
		CODE_ARG="--code"
	;;
esac

fission function create \
	--name ${ENVIRONMENT}-${FUNCTION_NAME} \
	--env ${FUNCTION_ENVIRONMENT} \
	${CODE_ARG} "${CODE_PATH}" \
	|| { 
		fission function update \
			--name ${ENVIRONMENT}-${FUNCTION_NAME} \
			${CODE_ARG} "${CODE_PATH}" 
	}

fission route create \
	--method ${FUNCTION_METHOD} \
	--url /${ENVIRONMENT}/${FUNCTION_NAME} \
	--function ${ENVIRONMENT}-${FUNCTION_NAME} \
	|| {
		ROUTE_NAME=$(fission route list | grep ${ENVIRONMENT}-${FUNCTION_NAME} | grep ${FUNCTION_METHOD} | grep "/${ENVIRONMENT}/${FUNCTION_NAME}" | awk '{ print $1 }')
		fission route update \
			--name ${ROUTE_NAME} \
			--function ${ENVIRONMENT}-${FUNCTION_NAME}
		}