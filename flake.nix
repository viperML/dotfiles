{
  description = "My awesome dotfiles";

  outputs = inputs: let
    inherit (inputs) self nixpkgs;
    supportedSystems = ["x86_64-linux"];
    config = import ./misc/nixpkgs.nix;
    inherit (builtins) mapAttrs readDir;
    inherit (nixpkgs.lib) attrValues genAttrs;
    inherit (self.lib) exportModulesDir;
  in {
    lib = import ./lib nixpkgs.lib;
    nixosModules = exportModulesDir ./modules/nixos;
    homeModules = exportModulesDir ./modules/home-manager;
    specialisations = import ./specialisations {inherit self inputs;};
    overlays = exportModulesDir ./overlays;
    nixosConfigurations = mapAttrs (name: _: import (./hosts + "/${name}") {inherit self inputs;}) (readDir ./hosts);

    # Propagate self.legacyPackages to NixOS and Home-manager, instead of configuring nixpkgs there
    legacyPackages = genAttrs supportedSystems (system:
      import inputs.nixpkgs {
        inherit config system;
        overlays = with inputs;
          [
            # nur.overlay
            # nixpkgs-wayland.overlay
            vim-extra-plugins.overlay
            emacs-overlay.overlay
            (_: prev: {
              inherit
                (inputs.nixpkgs-stable.legacyPackages.${system})
                mono
                ;
            })
          ]
          # Apply every exported overlay
          ++ (attrValues self.overlays);
      });

    packages =
      genAttrs supportedSystems (system:
        import ./packages self.legacyPackages.${system});

    devShells = genAttrs supportedSystems (system: {
      default = self.legacyPackages.${system}.callPackage ./misc/devShell.nix {};
    });
  };

  inputs = {
    # https://nixpk.gs/pr-tracker.html?pr=160343
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable-small";

    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-21.11";
    nixpkgs-master.url = "github:NixOS/nixpkgs/master";
    flake-utils-plus = {
      url = "github:gytis-ivaskevicius/flake-utils-plus";
      inputs.flake-utils.follows = "flake-utils";
    };
    flake-utils.url = "github:numtide/flake-utils";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };
    nur.url = "github:nix-community/NUR";
    deploy-rs = {
      url = "github:serokell/deploy-rs";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.utils.follows = "flake-utils";
      inputs.flake-compat.follows = "flake-compat";
    };
    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixpkgs-wayland = {
      url = "github:nix-community/nixpkgs-wayland";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-compat.follows = "flake-compat";
    };
    vim-extra-plugins = {
      url = "github:m15a/nixpkgs-vim-extra-plugins/42beca2847d7e5528dfa5f6c8daea86f1d6747af";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
      inputs.flake-compat.follows = "flake-compat";
    };
    emacs-overlay.url = "github:nix-community/emacs-overlay";
    nix-doom-emacs = {
      url = "github:nix-community/nix-doom-emacs";
      inputs.emacs-overlay.follows = "emacs-overlay";
      inputs.flake-utils.follows = "flake-utils";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    alejandra = {
      url = "github:kamadorueda/alejandra";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flakeUtils.follows = "flake-utils";
      inputs.flakeCompat.follows = "flake-compat";
    };
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
    nix-dram = {
      url = "github:dramforever/nix-dram";
      # inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };
  };
}
