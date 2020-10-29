#!/usr/bin/env bash

#create LXC
export CTID=$(pvesh get /cluster/nextid)
export PCT_OSTYPE=ubuntu
export PCT_OSVERSION=20
export PCT_DISK_SIZE=8
export PCT_OPTIONS="     
  -cmode shell
  -hostname PLEX
  -memory 4096
  -features nesting=1
  -net0 name=eth0,bridge=vmbr0,ip=dhcp
  -unprivileged 1
"
bash -c "$(wget -qLO - https://raw.githubusercontent.com/Saberwolf64/Proxmox-Nvidia-LXC-/proxmox-6.2-1-ubunutu-contributor-Whiskerz007/LXC_create.sh)"

#configure LXC
LXC_CONFIG=/etc/pve/lxc/${CTID}.conf
cat <<EOF >> $LXC_CONFIG
lxc.hook.pre-start: sh -c '[ ! -f /dev/nvidia-uvm ] && /usr/bin/nvidia-modprobe -c0 -u'
lxc.environment: NVIDIA_VISIBLE_DEVICES=all
lxc.environment: NVIDIA_DRIVER_CAPABILITIES=all
lxc.hook.mount: /usr/share/lxc/hooks/nvidia
lxc.hook.pre-start: sh -c 'chown :100000 /dev/nvidia*'
EOF

#Start LXC
pct start $CTID

#wait for lxc to report ip from DHCP
until lxc-info $CTID | grep -q IP;do 
  echo -ne "no ip found \033[0K\r"
done

#Update/upgrade and install plex,NVtop on LXC
lxc-attach -n $CTID -- apt -y install gnupg2
lxc-attach -n $CTID -- bash -c 'wget -q https://downloads.plex.tv/plex-keys/PlexSign.key -O - | apt-key add -'
lxc-attach -n $CTID -- bash -c 'echo "deb https://downloads.plex.tv/repo/deb/ public main" > /etc/apt/sources.list.d/plexmediaserver.list'
lxc-attach -n $CTID -- apt update
lxc-attach -n $CTID -- apt -y upgrade
lxc-attach -n $CTID -- apt -y install nvtop 
lxc-attach -n $CTID -- apt-get -y -o Dpkg::Options::="--force-confnew" install plexmediaserver
