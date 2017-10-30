#!/bin/bash

set -eux

/bin/helm lint ${SEARCH_PATH:-'.'}
