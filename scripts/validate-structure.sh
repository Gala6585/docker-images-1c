#!/usr/bin/env bash
set -euo pipefail
root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
required=(.env.example .gitignore .dockerignore Makefile compose.yaml images/v8unpack/Dockerfile scripts/build-v8unpack.sh images/1c-platform/Dockerfile images/vanessa-runner/Dockerfile images/vanessa-runner-allure/Dockerfile images/vanessa-runner-allure/scripts/run-vanessa.sh README.md)
for item in "${required[@]}"; do [[ -e "$root/$item" ]] || { echo "Отсутствует $item" >&2; exit 1; }; done
while IFS= read -r file; do
  relative="${file#"$root/"}"
  case "$relative" in
    distr/1c/*.deb|distr/oscript/*.deb|distr/oscript/*.zip|distr/*/.gitkeep) ;;
    *) echo "В distr найден неожиданный файл: $relative" >&2; exit 1 ;;
  esac
done < <(find "$root/distr" -type f -print)
grep -q '^\*\.deb$' "$root/.gitignore" || { echo '.gitignore не защищает .deb' >&2; exit 1; }
echo "Структура проверена"
