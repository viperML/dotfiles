{
  /*
   Simple flake to package an app in default.nix
   Using flake-utils to create the combo package+app
   
   See examples for default.nix in nixpkgs
   */

  description = "My awesome flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    flake-utils,
    ...
  }:
    flake-utils.lib.eachSystem ["x86_64-linux"] (system: let
      pkgs = nixpkgs.legacyPackages.${system};
    in rec {
      packages.myproject = pkgs.callPackage ./default.nix {};
      defaultPackage = packages.myproject;
      apps.myproject = flake-utils.lib.mkApp {
        drv = packages.myproject;
        exePath = "/bin/hello";
      };
      defaultApp = apps.myproject;
    });
}
