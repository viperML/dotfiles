{
  description = "My latex document";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    utils,
    ...
  }:
    utils.lib.mkFlake {
      inherit self inputs;

      channelsConfig = {allowUnfree = true;};

      outputsBuilder = channels: {
        packages = {
          my-latex-document = channels.nixpkgs.callPackage ./default.nix {};
        };
      };
    };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
  }:
    flake-utils.lib.eachDefaultSystem (
      system: let
        pkgs = nixpkgs.legacyPackages.${system};
        my-latex-document = pkgs.callPackage ./default.nix {};
      in rec {
        packages = {inherit my-latex-document;};
      }
    );
}
