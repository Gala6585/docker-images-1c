#!/usr/bin/env bash
set -euo pipefail
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/common.sh"
bash "$REPO_ROOT/scripts/validate-distr.sh"
docker build --build-arg "UBUNTU_VERSION=$UBUNTU_VERSION" --build-arg "ONEC_FULL_VERSION=$ONEC_FULL_VERSION" -f "$REPO_ROOT/images/1c-platform/Dockerfile" -t "$PLATFORM_IMAGE" "$REPO_ROOT"
