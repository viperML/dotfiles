#!/bin/sh
set -euxo pipefail

spec="$(< /run/current-system/configuration-name)"
host="$(< /etc/hostname)"
out="$(mktemp --dry-run --directory -t nh-XXXX)"

nix build --profile /nix/var/nix/profiles/system --out-link $out "$FLAKE#nixosConfigurations.$host.config.system.build.toplevel"

$out/specialisation/$spec/bin/switch-to-configuration "$@"
