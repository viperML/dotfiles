#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl gnused
set -euxo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")"

latest_version="$(curl --silent "https://api.github.com/repos/netbootxyz/netboot.xyz/releases/latest" | jq ".tag_name" -r)"

sed -i 's/version =.*/version = "'$latest_version'";/g' ./default.nix
