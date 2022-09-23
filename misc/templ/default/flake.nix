{
  description = "flake-parts based template";

  inputs = {
    # nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.05";
    flake-parts = {
      # url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    flake-parts,
    ...
  }:
    flake-parts.lib.mkFlake {inherit self;} {
      systems = nixpkgs.lib.systems.flakeExposed;
      perSystem = {pkgs, ...}: {
        devShells.default = pkgs.mkShellNoCC {
          name = "my-awesome-devshell";
          packages = [];
        };
      };
    };
}
