#!/usr/bin/env bash
set -euo pipefail
results="${ALLURE_RESULTS_DIR:-allure-results}"
report="${ALLURE_REPORT_DIR:-allure-report}"
[[ -d "$results" ]] || { echo "Каталог результатов не найден: $results" >&2; exit 1; }
allure generate --clean --output "$report" "$results"
