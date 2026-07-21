#!/usr/bin/env bash
set -euo pipefail
/usr/local/lib/onec/verify-platform.sh
/usr/local/lib/vanessa-runner/verify-vanessa-runner.sh
java -version
allure --version
command -v run-vanessa >/dev/null
