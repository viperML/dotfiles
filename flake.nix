{
  outputs = inputs:
    inputs.flake-parts.lib.mkFlake {inherit inputs;} ({
      lib,
      config,
      ...
    }: {
      imports = [
        ./packages
        ./misc/lib
        ./hosts
      ];

      flake = {
        nixosModules = config.flake.lib.dirToAttrs ./modules/nixos;
      };

      systems = [
        "x86_64-linux"
        "aarch64-linux"
      ];

      perSystem = {
        pkgs,
        config,
        ...
      }: {
        devShells.default = with pkgs;
          mkShellNoCC {
            packages = [
              lua-language-server
              config.packages.stylua
              taplo
            ];
          };
      };
    });

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    flake-parts = {
      url = "github:hercules-ci/flake-parts";
    };

    nix-common = {
      url = "github:viperML/nix-common";
    };
    tree-sitter = {
      url = "github:viperML/tree-sitter";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-parts.follows = "flake-parts";
    };
    nh = {
      url = "github:viperML/nh";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hover-rs = {
      url = "github:viperML/hover-rs";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    noshell = {
      url = "github:viperML/noshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    in-nix = {
      url = "github:viperML/in-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    wrapper-manager = {
      url = "github:viperML/wrapper-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    git-args = {
      url = "github:viperML/git-args";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    guix-search = {
      url = "github:viperML/guix-search";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };
    flake-utils = {
      url = "github:numtide/flake-utils";
    };

    nix-index-database = {
      url = "github:Mic92/nix-index-database";
    };
    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.4.1";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-parts.follows = "flake-parts";
      inputs.flake-utils.follows = "flake-utils";
      inputs.flake-compat.follows = "flake-compat";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.nixpkgs-stable.follows = "nixpkgs";
    };
    nixos-hardware = {
      url = "github:NixOS/nixos-hardware";
    };
    nil = {
      url = "github:oxalica/nil?ref=main";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-utils.follows = "flake-utils";
      };
    };
  };
}
