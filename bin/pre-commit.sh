#!/usr/bin/env bash

find . -name \*.nix -not -name deps.nix -exec alejandra {} \;
nix flake check

git add .
