#!/bin/bash
docker run --rm --privileged multiarch/qemu-user-static --reset -p yes
docker buildx create --use --name ci-builder
docker login -u="$DOCKER_USER" -p="$DOCKER_PASS"
docker buildx build --push --platform linux/amd64,linux/arm64,linux/arm/v7 -t ludoviclehmann/vcontrold:latest .
docker logout