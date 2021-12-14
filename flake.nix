{
  description = "Fernando Ayats's system configuraion";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";

    # Overlays
    nur.url = "github:nix-community/NUR";
  };

  outputs = inputs @ { self, nixpkgs, home-manager, flake-utils, nur, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {};
      in {

        nixosConfigurations = {
          gen6 = pkgs.lib.nixosSystem {
            system = "x86_64-linux";
            modules = [
              ./nixos/configuration.nix
              ./nixos/hosts/gen6.nix
            ];
            specialArgs = { inherit inputs; };
          };
        };

      }
    );

}
