#!/bin/bash
mkdir -p python/lib/python3.9/site-packages
pip install Pillow -t python/lib/python3.9/site-packages
cd python
zip -r ../pillow_layer.zip .
cd ..
rm -rf python