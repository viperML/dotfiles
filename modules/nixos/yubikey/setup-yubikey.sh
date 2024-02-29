#! /usr/bin/env bash
set -eux

mkdir -p ~/.config/Yubico
pamu2fcfg -o pam://$(hostname) -i pam://$(hostname) > ~/.config/Yubico/u2f_keys
