# OpenUSD Builder Image

`openusd-builder` is the reusable factory image for building Pixar OpenUSD in downstream
CI jobs. It contains the operating-system packages, Python modules, and build tools
expected by OpenUSD's `build_usd.py` workflow, plus Rez so downstream repositories can
create Rez packages. The image intentionally includes prerequisites for Python support,
imaging, usdview, MaterialX, tools, and examples/tutorial builds; it does not contain
compiled OpenUSD itself.

## Included

- Ubuntu 24.04
- GCC, G++, Make, CMake, and Ninja
- Git, curl, wget, unzip, tar, gzip, xz-utils, and pkg-config
- Python 3, Python development headers, pip, and venv support
- PySide6, PyOpenGL, and Jinja2 installed into the explicit OpenUSD build Python,
  `/usr/bin/python3`
- `pyside6-uic` on `PATH` for OpenUSD usdview/UI generation
- Rez installed in `/opt/rez` with `rez`, `rez-env`, and `rez-build` on `PATH`
- OpenGL, Mesa, X11, XCB, Xt, and related GUI development/runtime libraries
- TBB, Boost, OpenImageIO, and OpenEXR development libraries
- `smoke-test-openusd-builder`, a container smoke test command

## Python interpreter policy

The image intentionally separates OpenUSD's build Python from Rez's Python:

- `/usr/bin/python3` is the OpenUSD build Python. Use it for OpenUSD dependency
  checks and for downstream `build_scripts/build_usd.py` invocations so PySide6,
  PyOpenGL, and Jinja2 are imported from the interpreter where they were installed.
- `/opt/rez/bin/python` is only for Rez. Rez is installed in `/opt/rez`, and the Rez
  command-line tools are available on `PATH`.

`/opt/rez/bin` is placed on `PATH`, so plain `python3` may resolve to
`/opt/rez/bin/python3` instead of the system interpreter. Do not rely on plain
`python3` in OpenUSD build scripts or smoke checks; use `/usr/bin/python3` explicitly.

## Intentionally not included

This image does **not** contain:

- Pixar OpenUSD source code
- A compiled OpenUSD/USD installation
- A USD Rez package
- Studio-specific Rez package definitions or release rules

Those responsibilities belong to downstream package repositories such as
`studio-openusd`, with shared Rez standards supplied by `studio-rez`. In other words,
this image can run OpenUSD's `build_usd.py` unattended for the supported feature set, but
it is not itself an OpenUSD runtime image.


## Image Tags

The published GHCR image uses the flat image name:

```text
ghcr.io/vision-kwest/openusd-builder
```

The workflow builds this image once from `openusd-builder/Dockerfile`, runs the smoke
test, and then pushes multiple tags for the same tested image build:

- `latest` is convenient for testing and quick experiments, but it moves over time.
- `main` tracks the current `main` branch image.
- `26.05` is the human-readable builder tag intended for OpenUSD 26.05 package builds
  and is the recommended default for `studio-openusd` workflows.
- `sha-<commit>` is the audit/reproducibility tag for the exact `studio-ci-images`
  commit and should be recorded in the final USD Rez package manifest.

When `latest`, `main`, `26.05`, and `sha-*` are published by the same workflow run, they
may all point to the same image digest. These tags are references to the same pushed
image, not separate full image builds.

## Local build

From the `studio-ci-images` repository root:

```sh
docker build -t openusd-builder:local openusd-builder
```

## Local smoke test

```sh
docker run --rm openusd-builder:local smoke-test-openusd-builder
```

The smoke test is also copied to `/workspace/smoke-test.sh`, so this equivalent command
works too:

```sh
docker run --rm openusd-builder:local /workspace/smoke-test.sh
```

## Downstream studio-openusd usage

`studio-openusd` should mount its checkout into `/workspace`, then clone or use the
OpenUSD source, run Pixar's `build_usd.py`, execute tests, and create the USD Rez package
inside this container:

```sh
# Recommended default for OpenUSD 26.05 package builds:
docker run --rm -v "$PWD:/workspace" ghcr.io/vision-kwest/openusd-builder:26.05 bash
```

The image supplies the build factory and the known `build_usd.py` prerequisites for
OpenUSD 26.05 Python support, imaging, usdview, MaterialX, tools, and examples/tutorials.
`studio-openusd` owns the OpenUSD version, configuration flags, test policy, and Rez
packaging step.


`studio-openusd` should write the resolved image digest into the final USD Rez package
manifest so the package records the exact builder image used. The `sha-*` tag supports
audit and reproducibility, while `latest` should be limited to convenience and testing.
