#!/usr/bin/env bash
set -euxo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"

gh release view -R Mic92/nix-index-database --json "tagName" > $DIR/lock.json

tagName="$(jq -r ".tagName" $DIR/lock.json)"
sha256=$(nix-prefetch fetchurl --url "https://github.com/Mic92/nix-index-database/releases/download/$tagName/index-x86_64-linux")

jq -r ".sha256 = \"$sha256\"" $DIR/lock.json | sponge $DIR/lock.json
