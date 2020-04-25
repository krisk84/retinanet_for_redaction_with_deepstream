#!/bin/bash

SRCDIR="$PWD"

cd /data/open_images
bash /src/open_images/download_open_images.sh
bash /src/open_images/unzip_open_images.sh

cd "$SRCDIR"
python parse_validation_data.py
python parse_training_data.py
python copy_images.py
