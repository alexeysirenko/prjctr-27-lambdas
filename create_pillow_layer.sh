#!/usr/bin/env bash
set -euo pipefail

PY=3.12
ARCH_TAG=latest-x86_64
IMAGE="public.ecr.aws/sam/build-python${PY}:${ARCH_TAG}"

WORK=.layer_build
rm -rf "$WORK" && mkdir -p "$WORK/python"

docker run --rm -v "$PWD/$WORK/python":/var/task \
  "$IMAGE" \
  pip install --no-cache-dir Pillow==10.3.0 -t /var/task

pushd "$WORK" >/dev/null
zip -qr ../pillow_layer.zip .
popd
