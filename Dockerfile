# syntax=docker/dockerfile:1.15.1

FROM debian:bookworm-slim AS base
FROM base AS prepare

ARG OSMIUM_REPO=https://github.com/osmcode/libosmium.git
ARG OSMIUM_TOOL_REPO=https://github.com/osmcode/osmium-tool.git
ARG PROTOZERO_REPO=https://github.com/mapbox/protozero.git
ARG OSMIUM_VERSION=v2.22.0
ARG OSMIUM_TOOL_VERSION=v1.18.0
ARG PROTOZERO_VERSION=v1.8.0

WORKDIR /prepare

RUN apt-get update && apt-get install -y \
  git \
  g++ \
  cmake \
  nlohmann-json3-dev \
  libboost-program-options-dev \
  libexpat1-dev \
  libbz2-dev \
  zlib1g-dev \
  liblz4-dev \
  libexpat1-dev \
  pandoc \
  && \
  git clone --branch=${OSMIUM_VERSION} ${OSMIUM_REPO} && \
  git clone --branch=${OSMIUM_TOOL_VERSION} ${OSMIUM_TOOL_REPO} && \
  git clone --branch=${PROTOZERO_VERSION} ${PROTOZERO_REPO}

FROM prepare AS build

WORKDIR /build

COPY --from=prepare /prepare /build

RUN \
  cd osmium-tool && \
  mkdir build && \
  cd build && \
  cmake -DBoost_USE_STATIC_LIBS=ON \
        -DBoost_USE_DEBUG_RUNTIME=OFF \
        -DCMAKE_BUILD_TYPE=Release \
        -DBUILD_EXAMPLES=OFF \
        -DBUILD_TESTING=OFF \
        -DBoost_USE_MULTITHREADED=ON \
        -DPROTOZERO_HEADER_ONLY=ON \
  .. && \
  make

FROM base AS osmium-tool

LABEL image.author.name="sias32" \
      image.author.email="sias.32@yandex.ru" \
      image.version="1.18.0"

RUN apt-get update && apt-get install -y --no-install-recommends \
  libexpat1 \
  zlib1g \
  libbz2-1.0 \
  liblz4-1 \
  libstdc++6 \
  && rm -rf /var/lib/apt/lists/*

COPY --chmod=0755 --from=build /build/osmium-tool/build/src/osmium /usr/local/bin/osmium

ENTRYPOINT [ "osmium" ]
