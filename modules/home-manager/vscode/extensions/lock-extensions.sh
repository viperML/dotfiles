#!/usr/bin/env bash
set -eux pipefail

# Retrieve nixpkgs from environment
## Read the environment variable NIX_PATH into an array split by :
IFS=':' read -r -a nix_path <<< "$NIX_PATH"
## Get the value of the element which defines nixpkgs
for i in "${!nix_path[@]}"; do
    if [[ "${nix_path[i]}" == *"nixpkgs="* ]]; then
        nixpkgs_path="${nix_path[i]}"
        break # exit on first match
    fi
done
## Remove nixpkgs= from nixpkgs_path
nixpkgs_path="${nixpkgs_path#*nixpkgs=}"

mydir="$(dirname ${BASH_SOURCE[0]})"

exec "$nixpkgs_path"/pkgs/misc/vscode-extensions/update_installed_exts.sh > "${mydir}/extension-list.nix"
