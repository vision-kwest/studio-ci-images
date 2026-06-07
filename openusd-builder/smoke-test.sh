#!/usr/bin/env bash
set -euo pipefail

echo "== OpenUSD builder smoke test =="

gcc --version
g++ --version
cmake --version
ninja --version
git --version
rez --version
rez-env --help >/dev/null
pkg-config --version
dpkg -s libxt-dev >/dev/null

python3 --version
which python3
python3 -c "import sys; print(sys.executable)"
python3 -c "import PySide6; print('PySide6 OK')"
python3 -c "import OpenGL; print('PyOpenGL OK')"
python3 -c "import jinja2; print('Jinja2 OK')"

command -v pyside6-uic
pyside6-uic --version || pyside6-uic --help >/dev/null || true

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
