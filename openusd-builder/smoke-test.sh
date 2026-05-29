#!/usr/bin/env bash
set -euo pipefail

echo "== OpenUSD builder smoke test =="

gcc --version
g++ --version
cmake --version
ninja --version
python3 --version
git --version
rez --version
rez-env --help >/dev/null
pkg-config --version

venv_dir="$(mktemp -d)"
trap 'rm -rf "${venv_dir}"' EXIT
python3 -m venv "${venv_dir}/venv"

python3 - <<'PY'
import platform
import sys

print(f"platform={platform.platform()}")
print(f"python={sys.version}")
PY

echo "Smoke test completed successfully."
