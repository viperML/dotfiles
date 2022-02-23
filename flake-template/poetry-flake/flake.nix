{
  /*
   Flake template for poetry
   Requires an existing poetry project set up, with pyproject.toml
   You can generate one with
   $ nix run nixpkgs#poetry -- init
   
   See https://github.com/nix-community/poetry2nix
   for non-python dependencies, overrides, etc
   */

  description = "My awesome poetry project";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
    ...
  }:
    flake-utils.lib.eachSystem ["x86_64-linux"] (
      system: let
        pkgs = nixpkgs.legacyPackages.${system};
        python3 = pkgs.python3; # or any version
      in rec {
        packages.myproject = pkgs.callPackage ./default.nix {inherit python3;};
        apps.myproject = flake-utils.lib.mkApp {
          drv = packages.myproject;
          exePath = "/bin/myproject";
        };
        defaultApp = apps.myproject;
        devShell = pkgs.callPackage ./shell.nix {inherit python3;};
      }
    );
}
