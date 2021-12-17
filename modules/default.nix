{ utils }:
let
  nixosModules = utils.lib.exportModules [
    ./bat
    ./fish
    ./konsole
    ./lsd
    ./neofetch
    ./neovim
    ./nix-on-droid
    ./starship
    ./vscode

    ./base.nix
    ./cachix.nix
    ./git.nix
    ./home-base.nix
    ./home-fonts.nix
    ./home-gui.nix
    ./kvm.nix
    ./docker.nix
  ];
in
{
  inherit nixosModules;
}
