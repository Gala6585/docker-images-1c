#!/usr/bin/env bash
set -euo pipefail
root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
required=(.env.example .gitignore .dockerignore Makefile compose.yaml images/1c-platform/Dockerfile images/vanessa-runner/Dockerfile images/vanessa-runner-allure/Dockerfile images/vanessa-runner-allure/scripts/run-vanessa.sh README.md)
for item in "${required[@]}"; do [[ -e "$root/$item" ]] || { echo "Отсутствует $item" >&2; exit 1; }; done
if find "$root/distr" -type f ! -name .gitkeep ! -name '*.deb' -print -quit | grep -q .; then echo 'В distr найден неожиданный файл' >&2; exit 1; fi
grep -q '^\*\.deb$' "$root/.gitignore" || { echo '.gitignore не защищает .deb' >&2; exit 1; }
echo "Структура проверена"
