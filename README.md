# Studio CI Images

`studio-ci-images` is the source repository for reusable Docker CI/build images used by
a small VFX and animation studio pipeline. These images provide repeatable build
factories for downstream repositories; they do not build or publish production Rez
packages themselves.

## Pipeline architecture

- **`studio-ci-images`** builds Docker images that contain compilers, build tools,
  and common native dependencies.
- **`openusd-builder`** is the OpenUSD factory image in this repo. It is designed to
  have the tools needed for Pixar OpenUSD's `build_usd.py` workflow.
- **`studio-openusd`** consumes the `openusd-builder` image, clones Pixar OpenUSD,
  compiles and tests OpenUSD, then packages USD as a Rez package.
- **`studio-rez`** provides shared Rez configuration, package standards, scripts, and
  conventions used by package-producing repos such as `studio-openusd`.

This separation keeps the reusable build container stable while allowing downstream
repositories to own source checkout, version selection, tests, and package creation.

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

Published tags include:

- `latest`
- `main`
- `sha-<commit-sha>`
- an optional manual release tag such as `26.05` when supplied to the workflow dispatch
  input `image_tag`

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
docker pull ghcr.io/<owner>/openusd-builder:latest
```

## Downstream usage from studio-openusd

`studio-openusd` should run its OpenUSD source checkout, `build_usd.py` invocation,
test suite, and Rez package creation inside this image, for example:

```sh
docker run --rm -v "$PWD:/workspace" ghcr.io/<owner>/openusd-builder:latest bash
```

Inside that container, `studio-openusd` can apply `studio-rez` configuration and package
rules while this repo remains focused only on maintaining the reusable CI image.
