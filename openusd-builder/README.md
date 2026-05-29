# OpenUSD CI Docker Image

This repository builds and publishes a Docker image intended for OpenUSD build jobs.
The image is based on Ubuntu 24.04 and includes common compiler, build-system,
Rez, OpenGL/X11, TBB, Boost, OpenImageIO, and OpenEXR dependencies.

## Included tooling and libraries

- Ubuntu 24.04
- `gcc` / `g++`
- `cmake`
- `ninja-build`
- `python3`
- `git`
- `build-essential`
- Rez
- OpenGL and X11 development libraries
- TBB
- Boost
- OpenImageIO and OpenEXR development libraries

## Build locally

```sh
docker build -t openusd-build:local openusd-builder
```

## Published image

The GitHub Actions workflow publishes the image to GitHub Container Registry on
every push to the `main` branch:

```text
ghcr.io/<owner>/<repository>/openusd-builder:main
ghcr.io/<owner>/<repository>/openusd-builder:sha-<commit>
```
