let
  sources = import ../npins;
  pkgs = import ../packages;
in
(
  { modules }:
  import "${sources.nixpkgs}/nixos/lib/eval-config.nix" {
    system = null;
    modules = [
      {
        config.nixpkgs.pkgs = pkgs;
      }
      ../modules/nixos/common-gui.nix
      "${sources.nix-common}/nixos"
      (import sources.lanzaboote).nixosModules.lanzaboote
      (import sources.nix-maid).nixosModules.default
    ] ++ modules;
  }
)
