#!/usr/bin/env bash
DIR=$(cd "$(dirname "$0")"; pwd)
update-nix-fetchgit $DIR/default.nix
if [[ `git status --porcelain --untracked-files=no` ]]; then
    nix build .#bismuth
fi
