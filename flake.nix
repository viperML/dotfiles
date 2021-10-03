{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  inputs.homeManager.url = "github:nix-community/home-manager";
  inputs.homeManager.inputs.nixpkgs.follows = "nixpkgs";

  outputs = { self, nixpkgs, homeManager }: {
    homeManagerConfigurations = {
      ayats = homeManager.lib.homeManagerConfiguration {
        configuration = { pkgs, lib, ... }: {
          imports = [ ./ayats/home.nix ];
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