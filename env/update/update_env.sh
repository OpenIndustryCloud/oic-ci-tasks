#!/bin/bash

# This script deploys a Fission Function in a cluster for CI analysis
#
# Variables: 
#  - FUNCTION_ENVIRONMENT: name of the environment of the function: go, python, nodejs or binary
#  - FUNCTION_IMAGE: name of the image to use for that environment
#  - BUILDER_IMAGE: (Not used yet) if there is a specific builder image for the packaging


set -eux 

fission env update \
	--name ${FUNCTION_ENVIRONMENT} \
	--image ${FUNCTION_IMAGE} # --builder ${BUILDER_IMAGE}

