#!/usr/bin/env bash
set -euo pipefail
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/common.sh"

docker build \
  --build-arg "PYTHON_BASE_IMAGE=$V8UNPACK_PYTHON_BASE_IMAGE" \
  --build-arg "V8UNPACK_REPOSITORY=$V8UNPACK_REPOSITORY" \
  --build-arg "V8UNPACK_REF=$V8UNPACK_REF" \
  --build-arg "V8UNPACK_VERSION=$V8UNPACK_VERSION" \
  -f "$REPO_ROOT/images/v8unpack/Dockerfile" \
  -t "$V8UNPACK_IMAGE" \
  "$REPO_ROOT"
