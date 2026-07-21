#!/usr/bin/env bash
set -euo pipefail
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/common.sh"
kind="${1:?Использование: check-image.sh platform|runner|allure}"
case "$kind" in
  platform) image="$PLATFORM_IMAGE"; check=/usr/local/lib/onec/verify-platform.sh ;;
  runner) image="$RUNNER_IMAGE"; check=/usr/local/lib/vanessa-runner/verify-vanessa-runner.sh ;;
  allure) image="$ALLURE_IMAGE"; check=/usr/local/bin/verify-test-image ;;
  *) echo "Неизвестный тип образа: $kind" >&2; exit 2 ;;
esac
docker run --rm --entrypoint "$check" "$image"

