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
      ../modules/nixos/common.nix
      "${sources.nix-common}/nixos"
      {
        disabledModules = [
          "${sources.nix-common}/nixos/channels-to-flakes.nix"
        ];
      }
      (import sources.lanzaboote).nixosModules.lanzaboote
    ] ++ modules;
  }
)
