{
  description = "My awesome dotfiles";

  outputs = inputs @ {
    self,
    nixpkgs,
    ...
  }: let
    supportedSystems = ["x86_64-linux"];
    config = import ./misc/nixpkgs.nix;
  in {
    lib = import ./lib {inherit (nixpkgs) lib;};
    nixosModules = self.lib.exportModulesDir ./modules/nixos;
    homeModules = self.lib.exportModulesDir ./modules/home-manager;
    overlays = self.lib.exportModulesDir ./overlays;
    nixosConfigurations.gen6 = nixpkgs.lib.nixosSystem (import ./hosts/gen6 {inherit self inputs;});
    templates = import ./flake-templates;
    defaultTemplate = self.templates.base-flake;

    legacyPackages = nixpkgs.lib.genAttrs supportedSystems (system:
      import nixpkgs {
        inherit config system;
        overlays =
          [
            inputs.nur.overlay
            # inputs.nixpkgs-wayland.overlay
            inputs.vim-extra-plugins.overlay
            # inputs.emacs-overlay.overlay
            inputs.powercord-overlay.overlay
            (
              final: prev: {
                inherit
                  (import inputs.nixpkgs-master {inherit system config;})
                  vscode
                  ;
              }
            )
          ]
          ++ (nixpkgs.lib.attrValues self.overlays);
      });

    devShell = nixpkgs.lib.genAttrs supportedSystems (system: self.legacyPackages.${system}.callPackage ./misc/devShell.nix {});
  };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
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
    };
    vim-extra-plugins = {
      url = "github:m15a/nixpkgs-vim-extra-plugins";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
      inputs.flake-compat.follows = "flake-compat";
    };
    # emacs-overlay.url = "github:nix-community/emacs-overlay";
    # doom-emacs = {
    #   url = "github:vlaci/nix-doom-emacs";
    #   inputs.nixpkgs.follows = "nixpkgs";
    #   inputs.emacs-overlay.follows = "emacs-overlay";
    # };
    firefox-csshacks = {
      url = "github:MrOtherGuy/firefox-csshacks";
      flake = false;
    };
    powercord-overlay = {
      url = "github:LavaDesu/powercord-overlay";
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
    nix-gaming = {
      url = "github:fufexan/nix-gaming";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.utils.follows = "flake-utils-plus";
    };
  };
}
