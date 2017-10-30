#!/bin/sh

set -e -u -x

export GOPATH=$(pwd)/gopath:"${SEARCH_PATH}/../"

cd "${SEARCH_PATH}/.."

go test ./...
