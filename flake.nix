{
  description = "Fernando Ayats's system configuraion";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # Overlays
    nur.url = "github:nix-community/NUR";
  };

  outputs = inputs @ { self, nixpkgs, home-manager, nur }:
    let

      # Enable custom overlays here
      pkgs = import nixpkgs {
        inherit system;
        config = { allowBroken = true; allowUnfree = true; };
        overlays = [
          nur.overlay
        ];
      };

      # Change your platform here
      system = "x86_64-linux";

      # Change your username here
      username = "ayats";

    in {
      mkHM = {
        default = home-manager.lib.homeManagerConfiguration rec {
          # Home Manager shenaningans to pass the username down
          inherit system pkgs username;
          configuration = {
            imports = [
              # Basic cli
              ./nix/home.nix
              ./neovim/nvim.nix
              ./fish/fish.nix
              ./bat/bat.nix
              ./lsd/lsd.nix
              ./neofetch/neofetch.nix

              # Gui
              ./nix/fonts.nix
              ./vscode/vscode.nix
            ];
            home.username = username;
            home.homeDirectory = "/home/" + username;
            programs.home-manager = {
              enable = true;
              path = "…";
            };
          };
          homeDirectory = "/home/" + username;
        };
      };

    };
}
