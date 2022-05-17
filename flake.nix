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
    inherit (builtins) mapAttrs readDir;
    inherit (nixpkgs.lib) attrValues genAttrs;
    inherit (self.lib) exportModulesDir;
    genSystems = genAttrs supportedSystems;
  in {
    lib = import ./lib nixpkgs.lib;
    nixosModules = exportModulesDir ./modules/nixos;
    homeModules = exportModulesDir ./modules/home-manager;
    specialisations = import ./specialisations self;
    nixosConfigurations = mapAttrs (name: _: import (./hosts + "/${name}") inputs) (readDir ./hosts);

    legacyPackages = genSystems (system: inputs.nixpkgs-unfree.legacyPackages.${system});

    packages = genSystems (
      system:
        import ./packages inputs.nixpkgs-unfree.legacyPackages.${system} inputs
        # Packages to build and cache in CI
        // {
          inherit (inputs.nh.packages.${system}) nh;
          inherit (inputs.deploy-rs.packages.${system}) deploy-rs;
          devShell = self.devShells.${system}.default.inputDerivation;

          # Target for the rest of the system
          nix = inputs.nixpkgs.legacyPackages.${system}.nixUnstable;
        }
    );

    devShells = genSystems (system: {
      default = import ./shell.nix {
        pkgs = self.legacyPackages.${system} // self.packages.${system};
      };
    });
  };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-21.11";
    nixpkgs-master.url = "github:NixOS/nixpkgs/master";

    flake-utils.url = "github:numtide/flake-utils";
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };
    deploy-rs = {
      url = "github:serokell/deploy-rs";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.utils.follows = "flake-utils";
      inputs.flake-compat.follows = "flake-compat";
    };
    # emacs-overlay.url = "github:nix-community/emacs-overlay";
    # nix-doom-emacs = {
    #   url = "github:nix-community/nix-doom-emacs";
    #   inputs.emacs-overlay.follows = "emacs-overlay";
    #   inputs.flake-utils.follows = "flake-utils";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
    nh = {
      url = "github:viperML/nh";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };
    nixos-flakes = {
      url = "github:viperML/nixos-flakes";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
      inputs.flake-compat.follows = "flake-compat";
    };
    # nix-dram = {
    #   url = "github:dramforever/nix-dram";
    #   inputs.nixpkgs.follows = "nixpkgs";
    #   inputs.flake-utils.follows = "flake-utils";
    # };
    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
      inputs.flake-compat.follows = "flake-compat";
    };
    nixpkgs-unfree = {
      url = "github:numtide/nixpkgs-unfree";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-autobahn = {
      url = "github:Lassulus/nix-autobahn";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };
    nix-matlab = {
      url = "gitlab:doronbehar/nix-matlab";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-compat.follows = "flake-compat";
    };
    hyprland = {
      url = "path:/home/ayats/Downloads/Hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
}
