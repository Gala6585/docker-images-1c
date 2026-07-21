#!/usr/bin/env bash
set -euo pipefail

binary="$(find /opt /usr -type f -name 1cv8c -perm /111 -print -quit 2>/dev/null || true)"
if [[ -z "$binary" ]]; then
  echo "Не найден исполняемый файл 1cv8c" >&2
  exit 1
fi
ln -sfn "$binary" /usr/local/bin/1cv8c
command -v 1cv8c >/dev/null

