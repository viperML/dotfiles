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
    ./home-fonts.nix
  ];
in
{
  inherit nixosModules;
}
