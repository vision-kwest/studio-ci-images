# Studio CI Images

`studio-ci-images` is the source repository for reusable Docker CI/build images used by
a small VFX and animation studio pipeline. These images provide repeatable build
factories for downstream repositories; they do not build or publish production Rez
packages themselves.

## Pipeline architecture

- **`studio-ci-images`** builds Docker images that contain compilers, build tools,
  and common native dependencies.
- **`openusd-builder`** is the OpenUSD factory image in this repo. It is designed to
  have the tools needed for Pixar OpenUSD's `build_usd.py` workflow, including
  Python/usdview prerequisites such as PySide6, PyOpenGL, Jinja2, and the Xt
  development headers needed by MaterialX.
- **`studio-openusd`** consumes the `openusd-builder` image, clones Pixar OpenUSD,
  compiles and tests OpenUSD, then packages USD as a Rez package.
- **`studio-rez`** provides shared Rez configuration, package standards, scripts, and
  conventions used by package-producing repos such as `studio-openusd`.

This separation keeps the reusable build container stable while allowing downstream
repositories to own source checkout, version selection, tests, and package creation. The
builder image intentionally contains prerequisites for OpenUSD's `build_usd.py`; it does
not contain compiled OpenUSD itself.

## Image builders

```text
studio-ci-images/
├── openusd-builder/
├── rez-builder/
├── blender-builder/
└── render-tools/
```

Only `openusd-builder/` exists today. Future image builders should be added as sibling
directories with their own Dockerfiles, smoke tests, and documentation.

## Published image naming

The OpenUSD builder image is published to GitHub Container Registry with a flat,
owner-scoped name:

```text
ghcr.io/<owner>/openusd-builder
```

For example, a manually published studio release tag can be referenced as:

```text
ghcr.io/vision-kwest/openusd-builder:26.05
```

Downstream repositories should depend on this stable image name rather than the source
repository name. That keeps `studio-openusd` and other consumers insulated if this repo is
renamed or if image-builder source code is reorganized later.

## Image Tags

The OpenUSD builder image is published at the flat image name:

```text
ghcr.io/vision-kwest/openusd-builder
```

The publish workflow builds `openusd-builder/Dockerfile` once, runs the container smoke
test, and then pushes multiple tags that reference that same tested image build. The
standard tags are:

- `latest` is convenient for quick testing and ad-hoc pulls, but it moves over time.
- `main` tracks the current `main` branch image.
- `26.05` is the human-readable builder tag intended for OpenUSD 26.05 package builds
  and is the recommended default tag for `studio-openusd` workflows.
- `sha-<commit>` is the audit/reproducibility tag for the exact `studio-ci-images`
  commit and should be recorded in the final USD Rez package manifest.

Multiple tags do not mean multiple full images are stored when those tags point to the
same digest. `latest`, `main`, `26.05`, and `sha-*` may all be references to the same
pushed image digest.

`studio-openusd` should default to this image for OpenUSD 26.05 builds:

```text
ghcr.io/vision-kwest/openusd-builder:26.05
```

For reproducibility, `studio-openusd` should resolve the image digest used by the build
and write that digest into the final USD Rez package manifest. The `sha-*` tag is useful
for audit trails and reproducing a build from the exact `studio-ci-images` commit.

## Python interpreter policy

The OpenUSD builder image intentionally uses two explicit Python interpreters:

- `/usr/bin/python3` is the OpenUSD build Python. OpenUSD dependency checks and
  downstream `build_scripts/build_usd.py` invocations should use this interpreter so
  they see PySide6, PyOpenGL, and Jinja2.
- `/opt/rez/bin/python` is only for Rez. Rez remains installed in `/opt/rez`, and Rez
  commands are exposed on `PATH`.

Because `/opt/rez/bin` is on `PATH`, plain `python3` may resolve to
`/opt/rez/bin/python3` inside the container. Scripts should not rely on plain `python3`
for OpenUSD build dependency checks; use `/usr/bin/python3` explicitly.

## Build locally

From the repository root:

```sh
docker build -t openusd-builder:local openusd-builder
```

## Test locally

```sh
docker run --rm openusd-builder:local smoke-test-openusd-builder
```

## Pull from GHCR

```sh
docker pull ghcr.io/vision-kwest/openusd-builder:26.05
```

## Downstream usage from studio-openusd

`studio-openusd` should run its OpenUSD source checkout, `build_usd.py` invocation,
test suite, and Rez package creation inside this image, for example:

```sh
docker run --rm -v "$PWD:/workspace" ghcr.io/vision-kwest/openusd-builder:26.05 bash
```

Inside that container, `studio-openusd` can apply `studio-rez` configuration and package
rules while this repo remains focused only on maintaining the reusable CI image. The
image is a build environment only: it includes the Python, usdview, imaging, MaterialX,
tools, and examples/tutorial prerequisites expected by OpenUSD 26.05 builds, but it does
not ship a compiled USD install.
