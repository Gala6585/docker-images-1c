#!/usr/bin/env bash
set -euo pipefail
root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
for image in platform runner allure; do bash "$root/scripts/push-image.sh" "$image"; done
