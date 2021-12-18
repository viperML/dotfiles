#!/usr/bin/env bash
set -euo pipefail

rm -f result
unset NIX_PATH

echo
echo ":: Updating the 'nixpkgs' input in flake.nix"; set -x
nix flake update --update-input nixpkgs &>/dev/null
set +x

echo
echo ":: Using 'nixos-rebuild' to build the 'mysystem' toplevel"; set -x
nixos-rebuild build --flake '.#mysystem'
set +x
flake_path="$(readlink -f ./result)"

# extract rev from flake.lock so we can figure out the nixpkgs rev used
rev="$(cat flake.lock| jq -r '.nodes.nixpkgs.locked.rev')"
echo
echo ":: Using rev=${rev} for <nixpkgs> (extracted from flake.nix)"; set +x


rm -f result
nixpkgs="https://github.com/nixos/nixpkgs/archive/${rev}.tar.gz"
nixosconfig="$(pwd)/configuration.nix"

echo
echo ":: Setting NIX_PATH to the same values flakes is using"; set -x
NIX_PATH="nixpkgs=${nixpkgs}:nixos-config=${nixosconfig}" \
  nix-build '<nixpkgs/nixos>' -A config.system.build.toplevel
set +x

#  nixos-rebuild build

classic_path="$(readlink -f ./result)"

set +x
echo
echo "flake: ${flake_path}"
echo "clssc: ${classic_path}"

if [[ "${flake_path}" != "${classic_path}" ]]; then
  exit -1
fi

