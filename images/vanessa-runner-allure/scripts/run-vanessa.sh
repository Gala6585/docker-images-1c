#!/usr/bin/env bash
set -euo pipefail

CI_PROJECT_DIR="${CI_PROJECT_DIR:-/workspace}"
V8_PATH="${V8_PATH:-/usr/local/bin/1cv8c}"
VANESSA_EPF="${VANESSA_EPF:-tools/vanessa/vanessa-automation-single.epf}"
VA_PARAMS="${VA_PARAMS:-ci/VAParams.json}"
FEATURES_PATH="${FEATURES_PATH:-features}"
ALLURE_RESULTS_DIR="${ALLURE_RESULTS_DIR:-allure-results}"
ALLURE_REPORT_DIR="${ALLURE_REPORT_DIR:-allure-report}"
VANESSA_LOG_DIR="${VANESSA_LOG_DIR:-vanessa-logs}"
VANESSA_TIMEOUT_SECONDS="${VANESSA_TIMEOUT_SECONDS:-3600}"
: "${TEST_BASE_CONNECTION_STRING:?TEST_BASE_CONNECTION_STRING не задана}"

cd "$CI_PROJECT_DIR"
for file in "$VANESSA_EPF" "$VA_PARAMS"; do [[ -f "$file" ]] || { echo "Файл не найден: $file" >&2; exit 1; }; done
[[ -d "$FEATURES_PATH" ]] || { echo "Каталог feature-файлов не найден: $FEATURES_PATH" >&2; exit 1; }
for cmd in "$V8_PATH" xvfb-run dbus-run-session vrunner timeout; do command -v "$cmd" >/dev/null || { echo "Команда не найдена: $cmd" >&2; exit 1; }; done
if ldd "$V8_PATH" | grep -q 'not found'; then ldd "$V8_PATH" >&2; exit 1; fi
mkdir -p "$ALLURE_RESULTS_DIR" "$ALLURE_REPORT_DIR" "$VANESSA_LOG_DIR"

connection=(/IBConnectionString "$TEST_BASE_CONNECTION_STRING")
[[ -n "${TEST_BASE_USER:-}" ]] && connection+=(/N "$TEST_BASE_USER")
[[ -n "${TEST_BASE_PASSWORD:-}" ]] && connection+=(/P "$TEST_BASE_PASSWORD")
platform=("$V8_PATH" ENTERPRISE "${connection[@]}" /Execute "$VANESSA_EPF" /C"StartFeaturePlayer;VBParams=$VA_PARAMS")
echo "Запуск Vanessa Automation; пароль и строка подключения скрыты"
set +e
NO_AT_BRIDGE=1 timeout --signal=TERM --kill-after=30s "$VANESSA_TIMEOUT_SECONDS" \
  dbus-run-session -- xvfb-run -a -s "-screen 0 1280x1024x24" \
  "${platform[@]}" >"$VANESSA_LOG_DIR/platform.log" 2>&1
status=$?
set -e
if [[ $status -eq 124 ]]; then echo "Vanessa превысила timeout ${VANESSA_TIMEOUT_SECONDS}s" >&2; fi
if [[ $status -ne 0 ]]; then echo "Vanessa завершилась с кодом $status; логи сохранены в $VANESSA_LOG_DIR" >&2; exit "$status"; fi
