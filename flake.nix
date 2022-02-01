{
  description = "Personal infrastructure flake";

  outputs = inputs @ { self, nixpkgs, flake-utils-plus, ... }:
    let
      lib = nixpkgs.lib;
      modules = import ./modules { inherit flake-utils-plus lib; };
    in
    flake-utils-plus.lib.mkFlake {
      inherit self inputs;
      supportedSystems = [ "x86_64-linux" ];

      # Export modules
      inherit (modules) nixosModules homeModules;

      # Channels configurations
      channelsConfig.allowUnfree = true;
      overlay-pkgs = import ./overlay/overlay-pkgs.nix;
      overlay-patches = import ./overlay/overlay-patches.nix;
      channels.nixpkgs.overlaysBuilder = channels: [
        (final: prev: {
          # inherit (channels.nixpkgs-devel) libsForQt5;
        })
      ];
      sharedOverlays = [
        self.overlay-pkgs
        self.overlay-patches
        inputs.nur.overlay
        inputs.nixpkgs-wayland.overlay
        inputs.vim-extra-plugins.overlay
        # inputs.emacs-overlay.overlay
      ];

      # Hosts definitions
      hostDefaults.modules = with modules.nixosModules; [
        common
      ];

      hosts = {
        gen6.modules = with modules.nixosModules; [
          host-gen6
          desktop
          desktop-kde
          # desktop-gnome
          gnome-keyring

          mainUser-ayats
          inputs.home-manager.nixosModules.home-manager
          home-manager
          network
          adblock

          virt
          docker
          printing
          gaming
          vfio
        ] ++ [{
          home-manager.sharedModules = with modules.homeModules; [
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
          ];
        }];

      };

      # deploy.nodes = {
      # };
      # checks = builtins.mapAttrs (system: deployLib: deployLib.deployChecks self.deploy) inputs.deploy-rs.lib;

      outputsBuilder = channels:
        let
          pkgs = channels.nixpkgs;
        in
        {
          lib = let lib = pkgs.lib; in import ./lib { inherit pkgs lib; };

          devShell = pkgs.mkShell {
            name = "dotfiles-basic-shell";
            buildInputs = with pkgs; [
              git
              gnumake
              jq
              nixos-install-tools
              ripgrep
              unzip
            ];
            shellHook = ''
              export NIX_USER_CONF_FILES="$(pwd)/modules/nix.conf"
              echo -e "\n\e[34m❄ Welcome to viperML/dotfiles ❄"
              echo -e "\e[34m''$(nix --version)"
              echo -e "\e[0m"
            '';
          };

          devShellPlus = pkgs.mkShell {
            name = "dotfiles-advanced-shell";
            buildInputs = with pkgs; [
              git
              gnumake
              jq
              nixos-install-tools
              ripgrep
              update-nix-fetchgit
              inputs.deploy-rs.defaultPackage.${system}
            ];
            shellHook = ''
              export NIX_USER_CONF_FILES="$(pwd)/modules/nix.conf"
              echo -e "\n\e[34m❄ Welcome to viperML/dotfiles ❄"
              echo -e "\e[34m- ''$(nix --version)"
              echo "- Nixpkgs age:"
              curl https://api.github.com/repos/NixOS/nixpkgs/commits/`jq -r '.nodes.nixpkgs.locked.rev' ./flake.lock` -s | jq -r ".commit.author.date"
              echo -e "\n\e[34m❄ Changes to the running NixOS config: ❄"
              echo -e "\e[0m"
              git --no-pager diff $(nixos-version --json | jq -r '.configurationRevision') -p
            '';
          };

          packages = with pkgs; {
            inherit
              lightly
              sierrabreezeenhanced
              multiload-ng
              any-nix-shell
              papirus-icon-theme
              netboot-xyz-images
              reversal-kde
              plasma-applet-splitdigitalclock
              disconnect-tracking-protection
              stevenblack-hosts
              koi-fork
              plasma-theme-switcher
              ;
          } // {

            base-vm = inputs.nixos-generators.nixosGenerate {
              pkgs = pkgs;
              format = "qcow";
              modules = with modules.nixosModules; [
                mainUser-admin
              ];
            };

          };
        };

      templates = {
        poetry-flake = {
          path = ./templates/poetry-flake;
          description = "Flake for reproducible environments with poetry";
        };
        latex-flake = {
          path = ./templates/latex-flake;
          description = "Flake for reproducible latex documents";
        };
        base-flake = {
          path = ./templates/base-flake;
          description = "Basic flake with flake-utils-plus";
        };
      };

      defaultTemplate = self.templates.base-flake;
    };

  inputs = {
    nixpkgs.url = github:NixOS/nixpkgs/nixos-unstable;
    nixpkgs-stable.url = github:NixOS/nixpkgs/nixos-21.11;
    # nixpkgs-devel.url = github:viperML/nixpkgs/master;
    # nixpkgs-devel.url = "/home/ayats/Documents/nixpkgs";

    nixpkgs-LunNova-qt515-update.url = github:LunNova/nixpkgs/qt515-update;

    flake-utils-plus.url = github:gytis-ivaskevicius/flake-utils-plus/master;

    home-manager = {
      url = github:nix-community/home-manager;
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-compat = {
      url = github:edolstra/flake-compat;
      flake = false;
    };

    nur.url = github:nix-community/NUR;

    deploy-rs = {
      url = github:serokell/deploy-rs;
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-generators = {
      url = github:nix-community/nixos-generators;
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixpkgs-wayland.url = github:nix-community/nixpkgs-wayland;
    vim-extra-plugins = {
      url = "github:m15a/nixpkgs-vim-extra-plugins";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # emacs-overlay.url = github:nix-community/emacs-overlay;
    # doom-emacs = {
    #   url = github:vlaci/nix-doom-emacs;
    #   inputs.nixpkgs.follows = "nixpkgs";
    #   inputs.emacs-overlay.follows = "emacs-overlay";
    # };
    firefox-csshacks = {
      url = github:MrOtherGuy/firefox-csshacks;
      flake = false;
    };

  };
}
