#!/usr/bin/env bash

# Setup temporary environment
trap cleanup EXIT
function cleanup() {
  popd >/dev/null
  rm -rf $TMP_DIR
}
TMP_DIR=$(mktemp -d)
pushd $TMP_DIR >/dev/null

# Install NVidia drivers prerequisites
apt-get install -qqy pve-headers-`uname -r` gcc make 

# Install NVidia drivers
LATEST_DRIVER=$(wget -qLO - https://download.nvidia.com/XFree86/Linux-x86_64/latest.txt | awk '{print $2}')
LATEST_DRIVER_URL="https://download.nvidia.com/XFree86/Linux-x86_64/${LATEST_DRIVER}"
INSTALL_SCRIPT=$(basename $LATEST_DRIVER_URL)
wget -qLO $INSTALL_SCRIPT $LATEST_DRIVER_URL
bash $INSTALL_SCRIPT --silent

# Install NVidia Persistenced
#/usr/share/doc/NVIDIA_GLX-1.0/sample/nvidia-persistenced-init.tar.bz2 
if [ -f /usr/share/doc/NVIDIA_GLX-1.0/samples/nvidia-persistenced-init.tar.bz2 ]; then
  tar -jxvf /usr/share/doc/NVIDIA_GLX-1.0/samples/nvidia-persistenced-init.tar.bz2  
  bash ./nvidia-persistenced-init/install.sh
fi

# Install NVidia Container Runtime
wget -qLO - https://nvidia.github.io/nvidia-container-runtime/gpgkey | apt-key add - 
distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
wget -qLO - https://nvidia.github.io/nvidia-container-runtime/$distribution/nvidia-container-runtime.list | tee /etc/apt/sources.list.d/nvidia-container-runtime.list
apt-get update
apt-get install -qqy nvidia-container-runtime
