{
  description = "My awesome poetry application";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
    }:
      flake-utils.lib.eachDefaultSystem (
        system: let
          pkgs = nixpkgs.legacyPackages.${system};
          my-app-env = (
            pkgs.poetry2nix.mkPoetryEnv {
              projectDir = ./.;
            }
          )
          .env
          .overrideAttrs (
            prev: {
              buildInputs = with pkgs; [
                poetry
              ];
            }
          );
          my-app = pkgs.callPackage ./default.nix { };
        in
          rec {
            packages.my-app = my-app;
            apps.my-app = flake-utils.lib.mkApp {
              drv = packages.my-app;
              exePath = "/bin/my-app";
            };
            defaultApp = apps.my-app;
            devShell = my-app-env;
          }
      );
}
