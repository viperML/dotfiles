#! /usr/bin/env bash
set -x
unset SSH_ASKPASS

lib=/run/current-system/sw/lib/libtpm2_pkcs11.so

if ! ssh-add -L | grep --quiet libtpm2_pkcs11.so; then
    ssh-add -s $lib
fi

echo "key::$(ssh-keygen -D $lib)"

