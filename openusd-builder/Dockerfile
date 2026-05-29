# syntax=docker/dockerfile:1

FROM ubuntu:24.04

ARG DEBIAN_FRONTEND=noninteractive
ARG IMAGE_SOURCE="https://github.com/studio-ci-images"

LABEL org.opencontainers.image.title="OpenUSD Builder" \
      org.opencontainers.image.description="Reusable Ubuntu 24.04 CI factory image for building Pixar OpenUSD with build_usd.py." \
      org.opencontainers.image.source="${IMAGE_SOURCE}" \
      org.opencontainers.image.purpose="Provides build tools and dependencies only; downstream repos build and package OpenUSD."

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        ca-certificates \
        build-essential \
        gcc \
        g++ \
        make \
        cmake \
        ninja-build \
        git \
        curl \
        wget \
        unzip \
        tar \
        gzip \
        xz-utils \
        pkg-config \
        python3 \
        python3-dev \
        python3-pip \
        python3-venv \
        libgl1-mesa-dev \
        libglu1-mesa-dev \
        libglew-dev \
        libx11-dev \
        libxext-dev \
        libxi-dev \
        libxrandr-dev \
        libxcursor-dev \
        libxinerama-dev \
        libxxf86vm-dev \
        libxkbcommon-x11-0 \
        libxcb-xinerama0 \
        libxcb-image0 \
        libxcb-shape0 \
        libxcb-render-util0 \
        libxcb-icccm4 \
        libxcb-keysyms1 \
        libtbb-dev \
        libboost-all-dev \
        libopenimageio-dev \
        libopenexr-dev \
    && python3 -m venv /opt/rez \
    && /opt/rez/bin/pip install --no-cache-dir --upgrade pip \
    && /opt/rez/bin/pip install --no-cache-dir rez \
    && for tool in rez rez-env rez-build; do \
        if [ ! -e "/usr/local/bin/${tool}" ]; then \
            ln -s "/opt/rez/bin/${tool}" "/usr/local/bin/${tool}"; \
        fi; \
    done \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

COPY smoke-test.sh /usr/local/bin/smoke-test-openusd-builder
COPY smoke-test.sh /workspace/smoke-test.sh

RUN chmod +x /usr/local/bin/smoke-test-openusd-builder /workspace/smoke-test.sh

ENV REZ_HOME=/opt/rez \
    PATH="/opt/rez/bin:${PATH}"

WORKDIR /workspace

CMD ["/bin/bash"]
