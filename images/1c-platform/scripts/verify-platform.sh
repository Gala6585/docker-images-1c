#!/usr/bin/env bash
set -euo pipefail

binary="$(cat /usr/local/lib/onec/1cv8c.path)"
test -x "$binary"
library_path="$(dirname "$binary")${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"
if LD_LIBRARY_PATH="$library_path" ldd "$binary" | grep -q 'not found'; then
  LD_LIBRARY_PATH="$library_path" ldd "$binary" >&2
  exit 1
fi
test -x "$(command -v 1cv8c)"
command -v xvfb-run >/dev/null
command -v dbus-run-session >/dev/null
