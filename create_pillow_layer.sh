#!/usr/bin/env bash
set -euo pipefail

PY_VERSION=3.12                # match the Lambda runtime
LAYER_NAME=pillow_layer
BUILD_DIR=.layer_build

rm -rf "$BUILD_DIR" && mkdir -p "$BUILD_DIR/python"

docker run --rm \
  -v "$PWD/$BUILD_DIR":/var/task \
  "public.ecr.aws/sam/build-python${PY_VERSION}:latest" \
  /bin/sh -c "pip install --no-cache-dir Pillow==10.3.0 -t /var/task/python"

pushd "$BUILD_DIR" >/dev/null
zip -qr "../${LAYER_NAME}.zip" .
popd