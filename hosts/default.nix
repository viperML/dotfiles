let
  sources = import ../npins;
  pkgs = import ../packages;
in
modules:
pkgs.nixos (
  [
    ../modules/nixos/common-gui.nix
    "${sources.nix-common}/nixos"
    (import sources.lanzaboote {
      inherit pkgs;
    }).nixosModules.lanzaboote
    (import sources.nix-maid).nixosModules.default
  ]
  ++ modules
)
