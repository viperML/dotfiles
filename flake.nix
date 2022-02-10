{
  description = "Personal infrastructure flake";

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
        overlays = {
          pkgs = import ./overlays/pkgs;
          patches = import ./overlays/patches;
        };
        channels.nixpkgs.overlaysBuilder = channels: [
          (
            final: prev: {
              alejandra = inputs.alejandra.defaultPackage.x86_64-linux;
              # FIXME
            }
          )
        ];
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
        hostDefaults.modules =
          with modules.nixosModules;
          [
            common
          ];

        hosts = {
          gen6.modules =
            with modules.nixosModules;
            [
              host-gen6
              desktop
              desktop-kde
              # desktop-gnome
              # desktop-sway
              gnome-keyring

              mainUser-ayats
              inputs.home-manager.nixosModules.home-manager
              home-manager
              adblock

              virt
              docker
              printing
              gaming
              vfio
            ]
            ++ [
              {
                home-manager.sharedModules =
                  with modules.homeModules;
                  [
                    common
                    mainUser-ayats
                    flake-channels
                    fonts
                    gui
                    git

                    bat
                    fish
                    lsd
                    neofetch
                    neovim
                    vscode
                    kde
                    syncthing
                    kitty

                    # sway
                    # inputs.doom-emacs.hmModule
                    # emacs
                    firefox
                    # discord
                    # xonsh
                  ];
              }
            ];
        };

        # deploy.nodes = {
        # };
        # checks = builtins.mapAttrs (system: deployLib: deployLib.deployChecks self.deploy) inputs.deploy-rs.lib;

        templates = import ./templates;
        defaultTemplate = self.templates.base-flake;

        outputsBuilder = channels: let
          pkgs = channels.nixpkgs;
        in
          {
            devShell = import ./bin/devShell.nix { inherit pkgs; };
            # devShellPlus = import ./bin/devShellPlus.nix { inherit pkgs inputs ;
            # system = "${system}"; }; # FIXME
            packages =
              flake-utils-plus.lib.exportPackages self.overlays channels;
          };
      };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-21.11";
    flake-utils-plus.url = "github:gytis-ivaskevicius/flake-utils-plus";
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
    };
    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixpkgs-wayland.url = "github:nix-community/nixpkgs-wayland";
    vim-extra-plugins = {
      url = "github:m15a/nixpkgs-vim-extra-plugins";
      inputs.nixpkgs.follows = "nixpkgs";
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
    };
  };
}
