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

if command -v pyside6-uic >/dev/null; then
    pyside6-uic --version || command -v pyside6-uic
else
    echo "pyside6-uic was not found on PATH" >&2
    exit 1
fi

python3 -c "import PySide6"
python3 -c "import OpenGL"
python3 -c "import jinja2"
dpkg -s libxt-dev >/dev/null

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
