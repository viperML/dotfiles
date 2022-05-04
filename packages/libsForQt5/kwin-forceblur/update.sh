#!/usr/bin/env bash
update-nix-fetchgit ./default.nix
nix build .#kwin-forceblur
