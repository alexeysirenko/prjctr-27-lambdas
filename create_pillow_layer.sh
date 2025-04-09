#!/bin/bash
mkdir -p python/lib/python3.9/site-packages
pip install Pillow -t python/lib/python3.9/site-packages
zip -r pillow_layer.zip python
rm -rf python