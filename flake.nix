{
  description = "Fernando Ayats's system configuraion";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nur.url = "github:nix-community/NUR";
  };

  outputs = inputs @ { self, nixpkgs, home-manager, nur }:
    let

      pkgs = import nixpkgs {
        inherit system;
        config = { allowBroken = true; allowUnfree = true; };
        overlays = [
          nur.overlay
        ];
      };

      system = "x86_64-linux";

      # Change your username here
      username = "ayats";

    in {
      mkHM = {
        default = home-manager.lib.homeManagerConfiguration rec {
          inherit system pkgs username;
          configuration = { pkgs, lib, ... }: {
            imports = [
              # Split configs per package
              ./home-manager/home.nix
              ./neovim/nvim.nix
              ./fish/fish.nix
              ./bat/bat.nix
              ./lsd/lsd.nix
              ./neofetch/neofetch.nix
            ];
          };
          homeDirectory = "/home/" + username;
        };
      };

    };
}
