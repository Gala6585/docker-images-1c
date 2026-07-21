#!/usr/bin/env bash
set -euo pipefail
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/common.sh"
shopt -s nullglob
packages=("$REPO_ROOT"/distr/1c/*.deb)
thin=(); conflicts=()
for package in "${packages[@]}"; do
  name="$(basename "$package")"
  [[ "$name" == *thin-client*.deb ]] && thin+=("$package")
  [[ "$name" =~ (common|(^|[-_])client|server|ws|crs).*\.deb$ && "$name" != *thin-client*.deb ]] && conflicts+=("$package")
  [[ "$name" == *"$ONEC_FULL_VERSION"* ]] || { echo "Версия пакета не совпадает с $ONEC_FULL_VERSION: $name" >&2; exit 1; }
  arch="$(dpkg-deb -f "$package" Architecture 2>/dev/null || true)"
  [[ "$arch" == amd64 ]] || { echo "Неожиданная архитектура $arch: $name" >&2; exit 1; }
done
((${#thin[@]} > 0)) || { echo "Не найден пакет *thin-client*.deb в distr/1c" >&2; exit 1; }
((${#conflicts[@]} == 0)) || { printf 'Конфликтующие пакеты:\n%s\n' "${conflicts[*]}" >&2; exit 1; }
base_count=0; for p in "${thin[@]}"; do [[ "$(basename "$p")" != *thin-client-nls* ]] && ((base_count+=1)); done
((base_count == 1)) || { echo "Ожидался один основной thin-client пакет, найдено: $base_count" >&2; exit 1; }
if [[ "$INSTALL_OSCRIPT_FROM_LOCAL" == true ]]; then
  oscript=("$REPO_ROOT"/distr/oscript/*.deb); ((${#oscript[@]} > 0)) || { echo "Не найден OneScript .deb в distr/oscript" >&2; exit 1; }
else
  [[ "$OSCRIPT_VERSION" != latest ]] || { echo "OSCRIPT_VERSION должен быть фиксированным" >&2; exit 1; }
  [[ "$OSCRIPT_SHA256" =~ ^[0-9a-fA-F]{64}$ ]] || { echo "OSCRIPT_SHA256 должен содержать 64 hex-символа" >&2; exit 1; }
fi
echo "Дистрибутивы проверены"
