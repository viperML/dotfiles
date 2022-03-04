#!/usr/bin/env bash
set -eux

# Exit inmediately if we dont get $1
if [ -z "$1" ]; then
  echo "Usage: $0 <version>"
  exit 1
fi

spec="$(< /run/current-system/configuration-name)"
host="$(< /etc/hostname)"
out="$(mktemp --dry-run --directory -t nh-XXXX)"

nix build --profile /nix/var/nix/profiles/system --out-link $out "$FLAKE#nixosConfigurations.$host.config.system.build.toplevel"


if [ "$1" == "test" ]; then
    "$out/specialisation/$spec/bin/switch-to-configuration" test
elif [ "$1" == "boot" ]; then
    "$out/bin/switch-to-configuration" boot
elif [ "$1" == "switch" ]; then
    "$out/specialisation/$spec/bin/switch-to-configuration" test
    "$out/bin/switch-to-configuration" boot
fi
