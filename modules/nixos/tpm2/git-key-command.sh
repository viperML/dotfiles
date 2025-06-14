#! /usr/bin/env bash
set -u
unset SSH_ASKPASS

lib="/run/current-system/sw/lib/libtpm2_pkcs11.so"

pub="$(ssh-keygen -D $lib)"

if ! ssh-add -L | grep -q "$pub"; then
    echo "" | ssh-add -s "$lib" > /dev/null 2>&1
    exit=$?

    if [ $exit -ne 0 ]; then
        echo "Failed to add TPM2 key to ssh-agent" >&2
        exit 1
    fi
fi

echo "key::$pub"

