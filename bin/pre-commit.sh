#!/usr/bin/env bash

find . -name \*.nix -exec alejandra {} \;
nix flake check
