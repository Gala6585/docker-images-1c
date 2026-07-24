#!/usr/bin/env bash
set -euo pipefail

binary="$(find /opt /usr -type f -name 1cv8c -perm /111 -print -quit 2>/dev/null || true)"
if [[ -z "$binary" ]]; then
  echo "Не найден исполняемый файл 1cv8c" >&2
  exit 1
fi
printf '%s\n' "$binary" > /usr/local/lib/onec/1cv8c.path
cat > /usr/local/bin/1cv8c <<EOF
#!/usr/bin/env bash
set -e
binary="$binary"
export LD_LIBRARY_PATH="\$(dirname "\$binary")\${LD_LIBRARY_PATH:+:\$LD_LIBRARY_PATH}"
exec "\$binary" "\$@"
EOF
chmod +x /usr/local/bin/1cv8c
command -v 1cv8c >/dev/null
