{
  description = "My awesome dotfiles";

  outputs =
    inputs @
    { self
    , nixpkgs
    , flake-utils-plus
    , ...
    }:
    let
      inherit (nixpkgs) lib;
      modules = import ./modules { inherit flake-utils-plus lib; };
    in
      flake-utils-plus.lib.mkFlake {
        inherit self inputs;
        supportedSystems = [ "x86_64-linux" ];

        # Export modules
        inherit (modules) nixosModules homeModules;

        # Overlays and channels
        channelsConfig = import ./misc/nixpkgs.nix;
        channels.nixpkgs.overlaysBuilder = ch: [
          (
            final: prev: {
              # FIXME
              alejandra = inputs.alejandra.defaultPackage.x86_64-linux;
            }
          )
        ];
        overlays = {
          pkgs = import ./overlays/pkgs;
          patches = import ./overlays/patches;
        };
        sharedOverlays = [
          self.overlays.pkgs
          self.overlays.patches
          inputs.nur.overlay
          inputs.nixpkgs-wayland.overlay
          inputs.vim-extra-plugins.overlay
          # inputs.emacs-overlay.overlay
          inputs.powercord-overlay.overlay
        ];

        # Hosts definitions
        hostDefaults.modules = with modules.nixosModules; [ common ];
        hosts = {
          gen6 = import ./hosts/gen6 { inherit inputs modules; };
        };

        templates = import ./templates;
        defaultTemplate = self.templates.base-flake;

        outputsBuilder =
          channels: let
            pkgs = channels.nixpkgs;
            system = channels.nixpkgs.system;
          in
            {
              devShell = import ./bin/devShell.nix { inherit pkgs; };
              packages = flake-utils-plus.lib.exportPackages self.overlays channels;
              checks.pre-commit-check = inputs.pre-commit-hooks.lib.${system}.run {
                src = ./.;
                hooks = {
                  alejandra = {
                    enable = true;
                    name = "Format nix";
                    entry = "alejandra";
                    files = "\\.nix$";
                  };
                };
              };
            };
      };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-21.11";
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
    pre-commit-hooks = {
      url = "github:cachix/pre-commit-hooks.nix";
      inputs.flake-utils.follows = "flake-utils";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
}
