#!/usr/bin/env bash

fd -e nix -E deps --exec-batch alejandra {}
nix flake check

git add .
