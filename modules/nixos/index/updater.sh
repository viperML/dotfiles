#!/usr/bin/env nix-shell
#!nix-shell -i bash -p gh
set -euo pipefail

# Get path to this script
SCRIPT_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
gh release view -R Mic92/nix-index-database --json "tagName" > "${SCRIPT_PATH}/release.json"
