#!/usr/bin/env bash

# This script is completely copied and adapted from the Kubernetes coveralls.sh

# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

set -euo pipefail

[ -d /var/run/secrets/kubernetes.io/serviceaccount ] || {
  mkdir -p /var/run/secrets/kubernetes.io/serviceaccount
}

[ "x${KUBERNETES_CA}" = "x" ] || { 
  echo ${KUBERNETES_CA} | base64 --decode | tee /var/run/secrets/kubernetes.io/serviceaccount/ca.crt 
} 

[ "x${KUBERNETES_TOKEN}" = "x" ] || { 
  echo ${KUBERNETES_TOKEN} | base64 --decode | tee /var/run/secrets/kubernetes.io/serviceaccount/token 
} 

covermode=${COVERMODE:-atomic}
coverdir=$(mktemp -d /tmp/coverage.XXXXXXXXXX)
profile="${coverdir}/cover.out"

hash goveralls 2>/dev/null || go get github.com/mattn/goveralls
hash godir 2>/dev/null || go get github.com/Masterminds/godir

GOPATH="${GOPATH}:$(pwd)/function"
FNPATH="$(pwd)/function"
cd ${FNPATH}

generate_cover_data() {
  for d in $(godir) ; do
    (
      local output="${coverdir}/${d//\//-}.cover"
      go test -coverprofile="${output}" -covermode="$covermode" "$d"
    )
  done

  echo "mode: $covermode" >"$profile"
  grep -h -v "^mode:" "$coverdir"/*.cover >>"$profile"
}

push_to_coveralls() {
  goveralls -coverprofile="${profile}" -repotoken ${REPOTOKEN}
}

generate_cover_data
go tool cover -func "${profile}"

case "${1-}" in
  --html)
    go tool cover -html "${profile}"
    ;;
  --coveralls)
    push_to_coveralls
    ;;
esac

