#!/usr/bin/env bash
PNAME=adw-gtk3
nix-update -f $(git-root) $PNAME
if [[ `git status --porcelain --untracked-files=no` ]]; then
    nix build .#$PNAME
fi
