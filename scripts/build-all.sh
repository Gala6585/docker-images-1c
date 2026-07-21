#!/usr/bin/env bash
set -euo pipefail
root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
bash "$root/scripts/build-platform.sh"
bash "$root/scripts/build-vanessa-runner.sh"
bash "$root/scripts/build-vanessa-allure.sh"
