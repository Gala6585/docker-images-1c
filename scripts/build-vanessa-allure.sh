#!/usr/bin/env bash
set -euo pipefail
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/common.sh"
bash "$REPO_ROOT/scripts/validate-distr.sh"
docker build --build-arg "BASE_IMAGE=$RUNNER_IMAGE" --build-arg "ALLURE_VERSION=$ALLURE_VERSION" ${ALLURE_SHA256:+--build-arg "ALLURE_SHA256=$ALLURE_SHA256"} -f "$REPO_ROOT/images/vanessa-runner-allure/Dockerfile" -t "$ALLURE_IMAGE" "$REPO_ROOT"
