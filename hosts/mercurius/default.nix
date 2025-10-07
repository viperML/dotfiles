let
  sources = import ../../npins;
  pkgs = import ../../packages;
in
pkgs.nixos [
  ./configuration.nix
  (import "${sources.NixOS-WSL}/modules")

  ../../modules/nixos/common-console.nix
  "${sources.nix-common}/nixos"
  {
    disabledModules = [
      "${sources.nix-common}/nixos/network.nix"
    ];
  }
  # (import sources.lanzaboote).nixosModules.lanzaboote
  (import sources.nix-maid).nixosModules.default
]
