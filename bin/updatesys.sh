#!/bin/sh

pprint() {
    echo -e "\n==> \e[36m$1\e[39m"
}

prun() {
    pprint "$1"
    eval " $1" || die
}

prun_continue() {
    pprint "$1"
    eval " $1" || true
}

die() {
    echo -e "\n==> \e[31mEXIT!\e[39m"
    exit 1
}

pprint "Welcome to updatesys.sh 🐧"

prun_continue "zfs destroy zroot/gen6/gentoo@updatesys-old"
prun "zfs rename zroot/gen6/gentoo@updatesys zroot/gen6/gentoo@updatesys-old"
prun "zfs snap zroot/gen6/gentoo@updatesys"

prun "eix-sync"
prun "emerge --update --deep --newuse @world"
prun "emerge --depclean"
prun "smart-live-rebuild"

prun "zpool status"
