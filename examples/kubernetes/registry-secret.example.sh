#!/usr/bin/env bash
set -euo pipefail
: "${REGISTRY_SERVER:?}" "${REGISTRY_USER:?}" "${REGISTRY_PASSWORD:?}"
kubectl -n gitlab-runner create secret docker-registry gitlab-registry \
  --docker-server="$REGISTRY_SERVER" --docker-username="$REGISTRY_USER" \
  --docker-password="$REGISTRY_PASSWORD"
