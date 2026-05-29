# syntax=docker/dockerfile:1

FROM ubuntu:24.04

ARG DEBIAN_FRONTEND=noninteractive
LABEL org.opencontainers.image.title="OpenUSD Build Environment" \
      org.opencontainers.image.description="Ubuntu 24.04 image with compiler, CMake/Ninja, Rez, and common OpenUSD build dependencies."

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        ca-certificates \
        build-essential \
        gcc \
        g++ \
        cmake \
        ninja-build \
        python3 \
        python3-dev \
        python3-pip \
        python3-venv \
        git \
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
        libtbb-dev \
        libboost-all-dev \
        libopenimageio-dev \
        libopenexr-dev \
    && python3 -m venv /opt/rez \
    && /opt/rez/bin/pip install --no-cache-dir --upgrade pip \
    && /opt/rez/bin/pip install --no-cache-dir rez \
    && ln -s /opt/rez/bin/rez /usr/local/bin/rez \
    && ln -s /opt/rez/bin/rez-env /usr/local/bin/rez-env \
    && ln -s /opt/rez/bin/rez-build /usr/local/bin/rez-build \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

ENV REZ_HOME=/opt/rez \
    PATH="/opt/rez/bin:${PATH}"

WORKDIR /workspace

CMD ["/bin/bash"]
