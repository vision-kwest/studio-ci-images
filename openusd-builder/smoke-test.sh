#!/usr/bin/env bash
set -euo pipefail

SYSTEM_PYTHON=/usr/bin/python3
REZ_PYTHON=/opt/rez/bin/python

echo "== OpenUSD builder smoke test =="

gcc --version
g++ --version
cmake --version
ninja --version
git --version
pkg-config --version

echo "command -v python3 -> $(command -v python3)"
"${SYSTEM_PYTHON}" -c "import sys; print(sys.executable)"
"${REZ_PYTHON}" -c "import sys; print(sys.executable)"

"${SYSTEM_PYTHON}" --version
"${REZ_PYTHON}" --version

"${SYSTEM_PYTHON}" -c "import PySide6; print('PySide6 OK')"
"${SYSTEM_PYTHON}" -c "import OpenGL; print('PyOpenGL OK')"
"${SYSTEM_PYTHON}" -c "import jinja2; print('Jinja2 OK')"

rez --version
rez-env --help >/dev/null

dpkg -s libxt-dev >/dev/null

command -v pyside6-uic
pyside6-uic --version || pyside6-uic --help >/dev/null || true

venv_dir="$(mktemp -d)"
trap 'rm -rf "${venv_dir}"' EXIT
"${SYSTEM_PYTHON}" -m venv "${venv_dir}/venv"

"${SYSTEM_PYTHON}" - <<'PY'
import platform
import sys

print(f"platform={platform.platform()}")
print(f"python={sys.version}")
PY

echo "Smoke test completed successfully."
