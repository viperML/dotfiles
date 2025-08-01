#! /usr/bin/env bash
set -ux

rm -rvf ~/.local/share/tpm2-pkcs11
rm -rvf ~/.tpm2_pkcs11

tpm2_ptool init

tpm2_ptool addtoken --pid 1 --label ssh --userpin "" --sopin ""

tpm2_ptool addkey --label ssh --userpin "" --algorithm ecc256 --key-label "$USER $(hostname) tpm2"

ssh-keygen -D /run/current-system/sw/lib/libtpm2_pkcs11.so > ~/.ssh/tpm2.pub
