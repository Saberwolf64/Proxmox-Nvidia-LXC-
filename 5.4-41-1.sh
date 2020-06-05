#!/usr/bin/env bash

# Update Proxmox
apt-get update && apt-get upgrade -qqy

# Install NVidia drivers prerequisites
apt-get install -qqy pve-headers-`uname -r` gcc make

# Setup temporary environment
trap cleanup EXIT
function cleanup() {
  popd >/dev/null
  rm -rf $TEMP_DIR
}
TMP_DIR=$(mktemp -d)
pushd $TEMP_DIR >/dev/null

# Install NVidia drivers
LATEST_DRIVER=$(curl -sL https://download.nvidia.com/XFree86/Linux-x86_64/latest.txt | awk '{print $2}')
LATEST_DRIVER_URL="https://download.nvidia.com/XFree86/Linux-x86_64/${LATEST_DRIVER}"
INSTALL_SCRIPT=$(basename $LATEST_DRIVER_URL)
curl -sL $LATEST_DRIVER_URL -o $INSTALL_SCRIPT
bash $INSTALL_SCRIPT --disable-nouveau --ui=none

# Install NVidia Persistenced
#/usr/share/doc/NVIDIA_GLX-1.0/sample/nvidia-persistenced-init.tar.bz2 
tar -jxvf file.tar.bz2
bash ./nvidia-persistenced-init/install.sh

# Install NVidia Container Runtime
curl -s -L https://nvidia.github.io/nvidia-container-runtime/gpgkey | apt-key add -
distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
curl -s -L https://nvidia.github.io/nvidia-container-runtime/$distribution/nvidia-container-runtime.list | tee /etc/apt/sources.list.d/nvidia-container-runtime.list
apt-get update
apt-get install -qqy nvidia-container-runtime


#check nvidia-smi works check /dev/nvidia* for nvidia0 nvidia-modeset nvidia-uvm nvidia-uvm toolkit


# user must modify lxc config and add lines
#
#lxc.hook.pre-start: sh -c '[ ! -f /dev/nvidia-uvm ] && /usr/bin/nvidia-modprobe -c0 -u'
#lxc.environment: NVIDIA_VISIBLE_DEVICES=all
#lxc.environment: NVIDIA_DRIVER_CAPABILITIES=all
#lxc.hook.mount: /usr/share/lxc/hooks/nvidia
#lxc.hook.pre-start: sh -c 'chown :100000 /dev/nvidia*' # if your still having permission issuse run/add this line to your config
