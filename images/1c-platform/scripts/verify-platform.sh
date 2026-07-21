#!/usr/bin/env bash
set -euo pipefail

binary="$(command -v 1cv8c)"
test -x "$binary"
if ldd "$binary" | grep -q 'not found'; then
  ldd "$binary" >&2
  exit 1
fi
command -v xvfb-run >/dev/null
command -v dbus-run-session >/dev/null

