let
  sources = import ../../npins;
  pkgs = import ../../packages;
in

  import "${sources.nixpkgs}/nixos/lib/eval-config.nix" {
    system = null;
    modules = [
      {
        config.nixpkgs.pkgs = pkgs;
      }
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
    ];
  }
