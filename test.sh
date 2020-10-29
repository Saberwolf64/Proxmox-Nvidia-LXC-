#!/usr/bin/env bash

#remove proxmox ui nag
bash -c "$(wget -qLO - https://gist.githubusercontent.com/whiskerz007/53c6aa5d624154bacbbc54880e1e3b2a/raw/70b66d1852978cc457526df4a2913ca2974970a1/gistfile1.txt)"
# Update Proxmox
apt-get update && apt-get upgrade -qqy
#Driver install NVidia
bash -c "$(wget -qLO - https://raw.githubusercontent.com/Saberwolf64/Proxmox-Nvidia-LXC-/proxmox-6.2-1-ubunutu-contributor-Whiskerz007/Nvidia-driver-setup.sh)"
#Create lxc download install plex and nvtop
bash -c "$(wget -qLO - https://raw.githubusercontent.com/Saberwolf64/Proxmox-Nvidia-LXC-/proxmox-6.2-1-ubunutu-contributor-Whiskerz007/LXC_configure.sh)"