#!/bin/bash

WORKING_DIR="$PWD"

DESTDIR="$HOME"/redaction

# Some installs don't seem to have a /usr/local/cuda symlink, so hard set 10 for now
export PATH=${PATH}:/usr/local/cuda-10.0/bin
export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:/usr/local/cuda-10.0/lib64

# Paths and locations are a mess so just drop everything in the home dir
mkdir -p "$DESTDIR"

retinanet() {
cd "$WORKING_DIR"
cd retinanet-examples/extras/deepstream/deepstream-sample
mkdir build && cd build
cmake -DCMAKE_CUDA_FLAGS="--expt-extended-lambda -std=c++11" -DDeepStream_DIR=/opt/nvidia/deepstream/deepstream-4.0 ..
make -j $(nproc)
cp libnvdsparsebbox_retinanet.so "$DESTDIR"/
}

export_util() {
cd "$WORKING_DIR"
cd retinanet-examples/extras/cppapi
mkdir build && cd build
cmake -DCMAKE_CUDA_FLAGS="--expt-extended-lambda -std=c++11" ..
make -j $(nproc)
cp export "$DESTDIR"/
}

install_deps() {
sudo apt-get install libssl1.0.0 libgstreamer1.0-0 gstreamer1.0-tools gstreamer1.0-plugins-good \
 gstreamer1.0-plugins-bad gstreamer1.0-plugins-ugly gstreamer1.0-libav libgstrtspserver-1.0-0 \
 libjansson4=2.11-1 librdkafka1=0.11.3-1build1 libgstrtspserver-1.0-dev libopencv-dev
}

build_clean() {
rm -rf retinanet-examples/extras/deepstream/deepstream-sample/build
rm -rf retinanet-examples/extras/cppapi/build
rm -rf ~/deepstream-4.0/sources/apps/redaction
}

tensor_rt() {
cd "$WORKING_DIR"
cd retinanet-examples
if [ ! -r redaction.onnx ]; then
  ./get_redaction.sh
fi
cd "$DESTDIR"
if [ ! -r "$DESTDIR"/redaction_b1.plan ]; then
  time ./export "$WORKING_DIR"/retinanet-examples/redaction.onnx redaction_b1.plan
fi
}

# Assume deepstream is installed from deb
deepstream() {
cd "$WORKING_DIR"
if [ ! -d ~/deepstream-4.0 ]; then
  cp -a /opt/nvidia/deepstream/deepstream-4.0 ~
fi
mkdir ~/deepstream-4.0/sources/apps/redaction
cp -a Makefile src ~/deepstream-4.0/sources/apps/redaction/
cd ~/deepstream-4.0/sources/apps/redaction/
make -j $(nproc)
cp deepstream-redaction-app "$DESTDIR"/
}

configs() {
cd "$WORKING_DIR"
cp configs/odtk_model_config_fp16.txt configs/test_source1_fp16.txt "$DESTDIR"/
cp configs/nano.txt configs/agx.txt "$DESTDIR"/
}

if [ "$1" ]; then
  "$1"
else
  install_deps
  export_util
  retinanet
  tensor_rt
  deepstream
  configs
fi
