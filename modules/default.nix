{ utils }:
let
  nixosModules = utils.lib.exportModules [
    ./bat
    ./fish
    ./konsole
    ./kvm
    ./lsd
    ./neofetch
    ./neovim
    ./nix-on-droid
    ./starship

    ./git.nix
    ./home-base.nix
    ./home-fonts.nix
    ./home-gui.nix
  ];
in
{
  inherit nixosModules;
}
