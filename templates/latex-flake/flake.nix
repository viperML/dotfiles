{
  description = "Nix boilerplate for building latex documents";

  inputs = {
    nixpkgs.url = github:NixOS/nixpkgs/nixos-unstable;
    utils.url = github:gytis-ivaskevicius/flake-utils-plus;
  };

  outputs =
    inputs @
    { self
    , nixpkgs
    , utils
    , ...
    }:
    utils.lib.mkFlake {
      inherit self inputs;

      channelsConfig = { allowUnfree = true; };

      outputsBuilder = channels: {
        packages = {
          my-latex-document = channels.nixpkgs.callPackage ./default.nix { };
        };
      };
    };
}
