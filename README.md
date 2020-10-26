# Proxmox-Nvidia-LXC-
how to create an Proxmox LXC in 6.2-1 nvidia driver 455.28

install of Nvidia-container-runtime for Debian-based distributions 

curl -s -L https://nvidia.github.io/nvidia-container-runtime/gpgkey | \ apt-key add -
distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
 curl -s -L https://nvidia.github.io/nvidia-container-runtime/$distribution/nvidia-container-runtime.list | \
 tee /etc/apt/sources.list.d/nvidia-container-runtime.list
 apt-get update

updating repository keys

This project is maintained by NVIDIA
 curl -s -L https://nvidia.github.io/nvidia-container-runtime/gpgkey | \
  apt-key add -

you will need to modify your lxc config file /etc/pve/lxc/id#.conf and add the these line you must all so do this in an unprivileged CT
it will not work in a privileged

lxc.environment: NVIDIA_VISIBLE_DEVICES=all # forced environment var

lxc.environment: NVIDIA_DRIVER_CAPABILITIES=all # forced enviornment var

lxc.hook.mount: /usr/share/lxc/hooks/nvidia # hook script 

lxc.hook.pre-start: sh -c 'chown :100000 /dev/nvidia*' # was added due to permission issuse between host and client this will need to be done outside of config first

#Now you must download the nvidia drivers from Nvidia.com

wget http://us.download.nvidia.com/XFree86/Linux-x86_64/440.82/NVIDIA-Linux-x86_64-440.82.run # is the version i have tested to work with

#run installer 
bash NVIDIA-Linux-x86_64-440.82.run # fallow the on screen promts 

run the command nvidia-smi # to see if driver are working 

pct enter lxc id#

ls -l /dev/nvidia*

crw-rw-rw- 1 nobody root    195, 254 May 19 11:44 /dev/nvidia-modeset

crw-rw-rw- 1 nobody root    511,   0 May 19 11:44 /dev/nvidia-uvm

crw-rw-rw- 1 nobody root    511,   1 May 19 11:44 /dev/nvidia-uvm-tools

crw-rw-rw- 1 nobody nogroup 195,   0 May 19 11:44 /dev/nvidia0

crw-rw-rw- 1 nobody nogroup 195, 255 May 19 11:44 /dev/nvidiactl


 wget https://downloads.plex.tv/plex-media-server-new/1.19.3.2831-181d9145d/debian/plexmediaserver_1.19.3.2831-181d9145d_amd64.deb
 
 dpkg -i plexmediaserver_1.19.3.2831-181d9145d_amd64.deb
 
 systemctl status plexmediaserver # to make shure plex is running properly
 
 dpkg -L plexmediaserver to install plex into your repo so it can be updated with the apt manager
 
 change plex setting 127.0.0.1:32400/web # you will need to change plex setting in the advance menus to enable Hw Accel



REF websites
https://www.plex.tv/media-server-downloads/

https://support.plex.tv/articles/200288586-installation/

https://github.com/NVIDIA/nvidia-container-runtime

https://nvidia.github.io/nvidia-container-runtime/
