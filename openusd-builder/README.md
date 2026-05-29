# OpenUSD Builder Image

`openusd-builder` is the reusable factory image for building Pixar OpenUSD in downstream
CI jobs. It contains the operating-system packages and build tools expected by OpenUSD's
`build_usd.py` workflow, plus Rez so downstream repositories can create Rez packages.

## Included

- Ubuntu 24.04
- GCC, G++, Make, CMake, and Ninja
- Git, curl, wget, unzip, tar, gzip, xz-utils, and pkg-config
- Python 3, Python development headers, pip, and venv support
- Rez installed in `/opt/rez` with `rez`, `rez-env`, and `rez-build` on `PATH`
- OpenGL, Mesa, X11, XCB, and related GUI development/runtime libraries
- TBB, Boost, OpenImageIO, and OpenEXR development libraries
- `smoke-test-openusd-builder`, a container smoke test command

## Intentionally not included

This image does **not** contain:

- Pixar OpenUSD source code
- A compiled USD installation
- A USD Rez package
- Studio-specific Rez package definitions or release rules

Those responsibilities belong to downstream package repositories such as
`studio-openusd`, with shared Rez standards supplied by `studio-rez`.

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
docker run --rm -v "$PWD:/workspace" ghcr.io/<owner>/openusd-builder:latest bash
```

The image supplies the build factory. `studio-openusd` owns the OpenUSD version,
configuration flags, test policy, and Rez packaging step.
