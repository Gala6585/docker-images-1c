#!/usr/bin/env bash
set -euo pipefail
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/common.sh"
kind="${1:?Использование: push-image.sh platform|runner|allure}"
case "$kind" in platform) image="$PLATFORM_IMAGE";; runner) image="$RUNNER_IMAGE";; allure) image="$ALLURE_IMAGE";; *) exit 2;; esac
docker push "$image"

