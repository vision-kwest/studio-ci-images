# Studio CI Images

This repository contains Docker image builder projects for studio CI and build automation.
Each image builder is encapsulated in its own directory so additional images can be added
without crowding the repository root.

## Image builders

```text
studio-ci-images/
├── openusd-builder/
├── rez-builder/
├── blender-builder/
└── render-tools/
```

Only `openusd-builder/` exists today. The other directories are examples of how future
image builders can be organized.

## OpenUSD builder

The OpenUSD builder image definition lives in [`openusd-builder/`](openusd-builder/).
It is published by the GitHub Actions workflow in `.github/workflows/docker-publish.yml`.
