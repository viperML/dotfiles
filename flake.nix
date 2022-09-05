{
  description = "My awesome dotfiles";

  nixConfig = {
    extra-substituters = ["https://viperml.cachix.org"];
    extra-trusted-public-keys = ["viperml.cachix.org-1:qZhKBMTfmcLL+OG6fj/hzsMEedgKvZVFRRAhq7j8Vh8="];
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    flake-parts,
    ...
  }:
    flake-parts.lib.mkFlake {inherit self;} {
      imports = [
        ./packages
        ./lib
        ./lib/flake-parts.nix
        ./homes
        ./misc/shell.nix
        ./hosts
        ./modules
      ];

      flake = {
        specialisations = import ./misc/specialisations.nix inputs;
        templates = builtins.mapAttrs (name: _: {
          inherit (import ./misc/templ/${name}/flake.nix) description;
          path = ./misc/templ/${name};
        }) (builtins.readDir ./misc/templ);
      };

      perSystem = {
        pkgs,
        system,
        inputs',
        config,
        ...
      }: {
        _module.args.pkgs = import nixpkgs {
          inherit system;
          config.allowUnfreePredicate = drv:
            builtins.elem (nixpkgs.lib.getName drv) [
              "steam"
              "steam-original"
              "vscode"
              "corefonts"
              "obsidian"
              "google-chrome"
              "osu-lazer-bin"
              "nvidia-x11"
              "nvidia-settings"
              "nvidia-persistenced"
            ];
        };

        legacyPackages = pkgs;

        packages = {
          nh = inputs'.nh.packages.default;
          nil = inputs'.nil.packages.nil;
          deploy-rs = inputs'.deploy-rs.packages.deploy-rs;
          iosevka = inputs'.iosevka.packages.default;
          nix = inputs'.nix.packages.nix;

          zzz_devshell = config.devShells.default;
        };
      };

      systems = [
        "x86_64-linux"
        "aarch64-linux"
      ];
    };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-22.05";
    nixpkgs-master.url = "github:NixOS/nixpkgs/master";
    nix = {
      url = "github:NixOS/nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nh = {
      url = "github:viperML/nh";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-parts.follows = "flake-parts";
    };
    nix-common = {
      url = "github:viperML/nix-common";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager-wsl = {
      url = "github:viperML/home-manager-wsl";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
    iosevka = {
      url = "github:viperML/iosevka";
      # inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-parts.follows = "flake-parts";
    };

    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };
    flake-utils = {
      url = "github:numtide/flake-utils";
    };
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.utils.follows = "flake-utils";
    };
    deploy-rs = {
      url = "github:serokell/deploy-rs";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-compat.follows = "flake-compat";
    };
    nix-gaming = {
      url = "github:fufexan/nix-gaming";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland = {
      url = "github:hyprwm/Hyprland";
      # url = "github:viperML/Hyprland/nix-wlroots";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland-contrib = {
      url = "github:hyprwm/contrib";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-index-database = {
      url = "github:Mic92/nix-index-database";
    };
    nil = {
      url = "github:oxalica/nil";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };
  };
}
