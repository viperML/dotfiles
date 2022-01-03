{ flake-utils-plus, ... }:

let

  nixosModules = flake-utils-plus.lib.exportModules [
    ./nixos/common.nix
    ./nixos/desktop.nix
    ./nixos/docker.nix
    ./nixos/gaming.nix
    ./nixos/home-manager.nix
    ./nixos/host-gen6.nix
    ./nixos/host-hetzner.nix
    ./nixos/host-nix3.nix
    ./nixos/mainUser-admin.nix
    ./nixos/mainUser-ayats.nix
    ./nixos/minecraft-server.nix
    ./nixos/printing.nix
    ./nixos/virt.nix
  ];

  homeModules = flake-utils-plus.lib.exportModules [
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
    ./home-manager/discord.nix
    ./home-manager/kde
    ./home-manager/syncthing.nix
  ];

in

{
  inherit nixosModules homeModules;
}
