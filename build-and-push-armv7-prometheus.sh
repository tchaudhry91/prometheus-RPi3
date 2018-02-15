#!/bin/bash
set -e

IMAGE=prometheus-rpi3

# Pre-Build
mkdir bins || true

# Clone Prometheus Master
git clone https://github.com/prometheus/prometheus.git || true

# Inject Makefile.crossbuild
cp Makefile.crossbuild prometheus/Makefile

# Crossbuild for armv7/linux
cd prometheus
make build-armv7-linux

# Copy Binaries and Clean-Up
cp .build/linux-armv7/* ../bins/
cd ..

# Create Docker image
docker build -t $DOCKER_USERNAME/$IMAGE .

# Push Docker image
docker login -u "$DOCKER_USERNAME" -p "$DOCKER_PASSWORD"
docker push $DOCKER_USERNAME/$IMAGE
