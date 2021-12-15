{ utils }:
let
  nixosModules = utils.lib.exportModules [
    ./neofetch
    ./neovim
    ./fish
    ./starship
    ./lsd
    ./bat
    ./nix-on-droid
    ./konsole
    ./kvm
  ];
in
{
  inherit nixosModules;
}
