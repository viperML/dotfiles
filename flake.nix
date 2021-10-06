{
  # We take nixpkgs unstable as input
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  inputs.home-manager.url = "github:nix-community/home-manager";
  # Home-manager input should match nixpkgs
  inputs.home-manager.inputs.nixpkgs.follows = "nixpkgs";

  # We take nixpkgs and home-manager as input
  outputs = { self, nixpkgs, home-manager }: {
    # With that we export homeManagerConfigurations.user
    homeManagerConfigurations = {
      ayats = home-manager.lib.homeManagerConfiguration {
        configuration = { pkgs, lib, ... }: {
          imports = [
            # Split configs per package
            ./home-manager/home.nix
            ./neovim/nvim.nix
            ./fish/fish.nix
            ./bat/bat.nix
            ./lsd/lsd.nix
          ];
          nixpkgs = {
            config = { allowUnfree = true; };
          };
        };
        system = "x86_64-linux";
        homeDirectory = "/home/ayats";
        username = "ayats";
      };
    };
  };
}