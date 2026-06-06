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

The image supplies the build factory. `studio-openusd` owns the OpenUSD version,
configuration flags, test policy, and Rez packaging step.


`studio-openusd` should write the resolved image digest into the final USD Rez package
manifest so the package records the exact builder image used. The `sha-*` tag supports
audit and reproducibility, while `latest` should be limited to convenience and testing.
