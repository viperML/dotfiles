{ utils }:

let
  nixosModules = utils.lib.exportModules [
    ./base-home.nix
    ./bat
    ./fish
    ./git.nix
    ./home-fonts.nix
    ./home-gui.nix
    ./konsole
    ./lsd
    ./neofetch
    ./neovim
    ./nix-on-droid
    ./vscode

    ./nixos/nixos-base.nix
    ./nixos/nixos-gen6.nix
    ./nixos/nixos-vm.nix

    ./kvm.nix
    ./docker.nix
  ];
in
{
  inherit nixosModules;
}
