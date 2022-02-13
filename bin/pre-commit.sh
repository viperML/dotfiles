#!/usr/bin/env bash

find . -name \*.nix -not -name deps.nix -exec alejandra {} \; > /dev/null
nix flake check

git add .
