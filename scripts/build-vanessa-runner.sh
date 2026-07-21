#!/usr/bin/env bash
set -euo pipefail
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/common.sh"
bash "$REPO_ROOT/scripts/validate-distr.sh"
docker build --build-arg "BASE_IMAGE=$PLATFORM_IMAGE" --build-arg "INSTALL_OSCRIPT_FROM_LOCAL=$INSTALL_OSCRIPT_FROM_LOCAL" --build-arg "OSCRIPT_VERSION=$OSCRIPT_VERSION" --build-arg "OSCRIPT_SHA256=$OSCRIPT_SHA256" --build-arg "VANESSA_RUNNER_VERSION=$VANESSA_RUNNER_VERSION" -f "$REPO_ROOT/images/vanessa-runner/Dockerfile" -t "$RUNNER_IMAGE" "$REPO_ROOT"
