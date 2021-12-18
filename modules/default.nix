{ utils }:

let
  homeModules = utils.lib.exportModules [
    ./base-home.nix
    ./bat
    ./cachix.nix
    ./fish
    ./git.nix
    ./home-fonts.nix
    ./home-gui.nix
    ./konsole
    ./lsd
    ./neofetch
    ./neovim
    ./nix-on-droid
    ./starship
    ./vscode
  ];

  nixosModules = utils.lib.exportModules [
    ./nixos/nixos-base.nix
    ./nixos/nixos-gen6.nix
    ./nixos/nixos-vm.nix

    ./kvm.nix
    ./docker.nix
    ./android-emulation.nix
  ];
in
{
  inherit homeModules nixosModules;
}
