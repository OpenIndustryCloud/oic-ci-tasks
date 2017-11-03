#!/bin/bash

# This script will run a newman/postman query against an API
cat "${COLLECTION}" | \
	jq ".item[].request.method = \"${FUNCTION_METHOD}\" | \
		.item[].request.url.raw = \"${PROTOCOL}://${FISSION_ROUTER}:${TARGET_PORT}/${ENVIRONMENT}/${FUNCTION_NAME}\" | \
		.item[].request.url.host = [ \"${FISSION_ROUTER}\" ] | \
		.item[].request.url.path = [ \"${ENVIRONMENT}\", \"${FUNCTION_NAME}\" ] | \
		.item[].request.url.port = \"${TARGET_PORT}\"" \
		> /tmp/collection.json

newman run /tmp/collection.json
