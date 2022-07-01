{
  description = "My awesome dotfiles";

  nixConfig = {
    extra-substituters = ["https://viperml.cachix.org"];
    extra-trusted-public-keys = ["viperml.cachix.org-1:qZhKBMTfmcLL+OG6fj/hzsMEedgKvZVFRRAhq7j8Vh8="];
  };

  outputs = inputs: let
    inherit (inputs) self nixpkgs;
    supportedSystems = ["x86_64-linux"];
    config = import ./misc/nixpkgs.nix;
    inherit (builtins) mapAttrs readDir elem;
    inherit (nixpkgs.lib) attrValues genAttrs recursiveUpdate getName;
    inherit (self.lib) exportModulesDir;
    genSystems = genAttrs supportedSystems;
  in {
    lib = import ./lib {
      inherit (nixpkgs) lib;
      inherit inputs;
    };
    nixosModules = builtins.removeAttrs (exportModulesDir ./modules/nixos) ["users"];
    homeModules = exportModulesDir ./modules/home-manager;
    specialisations = import ./specialisations self;
    nixosConfigurations = mapAttrs (name: _: import (./hosts + "/${name}") inputs) (readDir ./hosts);
    homeConfigurations = mapAttrs (name: _: import (./homes + "/${name}") inputs) (readDir ./homes);

    legacyPackages = genSystems (system:
      (import inputs.nixpkgs {
        inherit system;
        config.allowUnfree = true;
      })
      // (import ./lib/perSystem.nix inputs.nixpkgs.legacyPackages.${system}));

    packages =
      recursiveUpdate (genSystems (
        system:
          import ./packages self.legacyPackages.${system} inputs
          # Packages to build and cache in CI
          // {
            nh = inputs.nh.packages.${system}.default;
            inherit (inputs.deploy-rs.packages.${system}) deploy-rs;

            # Target for the rest of the system
            nix = inputs.nix.packages.${system}.nix;

            _devShell = self.devShells.${system}.default.inputDerivation;

            update-nix-fetchgit = inputs.nixpkgs.legacyPackages.${system}.update-nix-fetchgit.overrideAttrs (prev: {
              doCheck = false;
            });
          }
      )) {
        "x86_64-linux" = {
          _homeConfigurations-ayats-viperSL4 = self.homeConfigurations."ayats@viperSL4".activationPackage;
        };
      };

    devShells = genSystems (system: {
      default = import ./shell.nix {
        pkgs = self.legacyPackages.${system} // self.packages.${system};
      };
    });

    templates = mapAttrs (name: _: {
      inherit (import ./templ/${name}/flake.nix) description;
      path = ./templ/${name};
    }) (readDir ./templ);
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
    };
    nix-common = {
      url = "github:viperML/nix-common";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    deploy-rs = {
      url = "github:serokell/deploy-rs";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-autobahn = {
      url = "github:Lassulus/nix-autobahn";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-matlab = {
      url = "gitlab:doronbehar/nix-matlab";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # emacs-overlay = {
    #   url = "github:nix-community/emacs-overlay";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
    # nix-doom-emacs = {
    #   url = "github:nix-community/nix-doom-emacs";
    #   inputs.emacs-overlay.follows = "emacs-overlay";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
    nix-std.url = "github:chessai/nix-std";
    nix-gaming = {
      url = "github:fufexan/nix-gaming";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
}
