#!/bin/bash

set -eux pipefail

export GOPATH=$(pwd)/gopath:"${SEARCH_PATH}"

cd "${SEARCH_PATH}/"

go test --run .
