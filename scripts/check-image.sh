#!/usr/bin/env bash
set -euo pipefail
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/common.sh"
kind="${1:?Использование: check-image.sh platform|runner|allure|v8unpack}"
case "$kind" in
  platform) image="$PLATFORM_IMAGE"; check=/usr/local/lib/onec/verify-platform.sh ;;
  runner) image="$RUNNER_IMAGE"; check=/usr/local/lib/vanessa-runner/verify-vanessa-runner.sh ;;
  allure) image="$ALLURE_IMAGE"; check=/usr/local/bin/verify-test-image ;;
  v8unpack) image="$V8UNPACK_IMAGE"; check=python ;;
  *) echo "Неизвестный тип образа: $kind" >&2; exit 2 ;;
esac
if [[ "$kind" == v8unpack ]]; then
  docker run --rm --entrypoint "$check" "$image" -c 'import v8unpack.version as v; print(v.__version__)'
else
  docker run --rm --entrypoint "$check" "$image"
fi
