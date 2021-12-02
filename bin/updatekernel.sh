#!/bin/sh

pprint() {
    echo -e "\n==> \e[36m$1\e[39m"
}

prun() {
    pprint "$1"
    eval " $1"
}

die() {
    echo -e "\n==> \e[31mEXIT!\e[39m"
    exit 1
}

pprint "Welcome to updatekernel.sh 🐧"

KDIR="/usr/src/$(readlink /usr/src/linux)"
KERNEL_LOCALVERSION="$(grep "KERNEL_LOCALVERSION=" /etc/genkernel.conf | sed 's/KERNEL_LOCALVERSION=//g;s/\"//g')"
KVER="$(readlink /usr/src/linux | sed 's/linux-//g')1$KERNEL_LOCALVERSION"

pprint "Available kernels: "

for ker in $(find /usr/src -maxdepth 2 -name 'linux-*')
do
    if [[ "$ker" == "$KDIR" ]]; then
        echo -e "[\e[34m*\e[39m] $ker"
    else
        echo "[ ] $ker"
    fi
done

pprint "Is this OK? (Y/n)"
read

if [[ ! -z "$REPLY" ]] && [[ ! "$REPLY" =~ ^[yY]$ ]]; then
    die
fi

prun "zfs snap zroot/gen6/gentoo@updatekernel"
prun "genkernel --kerneldir=$KDIR --kernel-config=/proc/config.gz kernel" || die

if [[ -f "/boot/initramfs-$KVER.img" ]]; then
    prun "mv /boot/initramfs-$KVER.img /boot/initramfs-$KVER.img.old"
fi

prun "dracut --kver $KVER" || die

prun "eclean-kernel -n 3 -s mtime" || die
