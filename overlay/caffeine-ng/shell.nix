{ pkgs ? import (builtins.fetchTarball {
    name = "nixos-unstable-2022-01-11";
    url = "https://github.com/nixos/nixpkgs/archive/b2737d4980a17cc2b7d600d7d0b32fd7333aca88.tar.gz";
    sha256 = "012db5d6k0lajp4q37byhgamz3ry04av1dcpgf3ahm9kzjwsjcch";
  }) { }
}:
{
  caffeine-ng = pkgs.callPackage ./. { pP = pkgs.python39Packages; };
}
