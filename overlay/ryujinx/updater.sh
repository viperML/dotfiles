#! /usr/bin/env nix-shell
#! nix-shell -i bash -p coreutils gnused curl nuget-to-nix dotnet-sdk_6 update-nix-fetchgit
set -exo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")"

deps_file="$(realpath "./deps.nix")"


update-nix-fetchgit ./default.nix
sed -i 's/version =.*/version = "0.0.0";/g' "$(realpath "./default.nix")"


nix build --impure --expr 'let pkgs = import (builtins.getFlake "nixpkgs") {}; in (pkgs.callPackage ./default.nix {}).src'
src="$(mktemp -d /tmp/ryujinx-src.XXX)"
cp -r result/* "$src"
chmod -R +w "$src"
pushd "$src"

mkdir nuget_tmp.packages
dotnet restore Ryujinx.sln --packages nuget_tmp.packages

nuget-to-nix ./nuget_tmp.packages > "$deps_file"

popd
rm -r "$src"
