#! /usr/bin/env bash
set -eux

NAME=spack

mkdir -p ~/.local/state/spack-cont

podman run -it \
    --name "$NAME" \
    -v /nix:/nix:ro \
    -v /run/current-system:/run/current-system:ro \
    -v ~/.local/state/spack-cont:/home \
    "$@" \
    -u ubuntu \
    ubuntu:24.04 \
    sh

