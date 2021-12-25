{ utils }:

let
  nixosModules = utils.lib.exportModules [
    ./nixos/base.nix
    ./nixos/docker.nix
    ./nixos/home-manager.nix
    ./nixos/host-gen6.nix
    ./nixos/host-vm.nix
    ./nixos/kvm.nix
  ];
  homeModules = utils.lib.exportModules [
    ./home-manager/bat
    ./home-manager/fish
    ./home-manager/konsole
    ./home-manager/lsd
    ./home-manager/neofetch
    ./home-manager/neovim
    ./home-manager/starship
    ./home-manager/vscode
    ./home-manager/base.nix
    ./home-manager/fonts.nix
    ./home-manager/git.nix
    ./home-manager/gui.nix
    ./home-manager/flake-channels.nix
  ];
in
{
  inherit nixosModules homeModules;
}
