{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  inputs.home-manager.url = "github:nix-community/home-manager";
  inputs.home-manager.inputs.nixpkgs.follows = "nixpkgs";

  outputs = { self, nixpkgs, home-manager }: {
    home-managerConfigurations = {
      ayats = home-manager.lib.home-managerConfiguration {
        configuration = { pkgs, lib, ... }: {
          imports = [ ./home.nix ];
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