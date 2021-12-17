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
    ./base-home.nix
    ./cachix.nix
    ./git.nix
    ./home-fonts.nix
    ./home-gui.nix
    ./kvm.nix
    ./docker.nix
    ./android-emulation.nix
  ];
in
{
  inherit nixosModules;
}
