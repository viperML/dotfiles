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
      overlay = import ./overlay;
      sharedOverlays = [
        self.overlay
        inputs.nur.overlay
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

          mainUser-ayats
          inputs.home-manager.nixosModules.home-manager
          home-manager

          virt
          docker
          printing
          gaming
        ] ++ [{
          home-manager.sharedModules = with modules.homeModules; [
            base
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
          ];
        }];

      };

      # deploy.nodes = {
      # };
      # checks = builtins.mapAttrs (system: deployLib: deployLib.deployChecks self.deploy) inputs.deploy-rs.lib;

      nixOnDroidConfigurations.my-device = inputs.nix-on-droid.lib.nixOnDroidConfiguration {
        system = "aarch64-linux";
        extraSpecialArgs = { inputs = inputs; };
        config = ./modules/nix-on-droid;
        extraModules = [
          {
            home-manager.sharedModules = with modules.homeModules; [
              flake-channels
              fish
              neovim
              git
              neofetch
              lsd
              bat
            ];
          }
        ];
      };


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
            ];
            shellHook = ''
              export NIX_USER_CONF_FILES="$(pwd)/modules/nix.conf"
              export FLAKE="/home/ayats/Documents/dotfiles"
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
              export FLAKE="/home/ayats/Documents/dotfiles"
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

    flake-utils-plus.url = github:gytis-ivaskevicius/flake-utils-plus/v1.3.1;

    home-manager = {
      url = github:nix-community/home-manager;
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-on-droid = {
      url = github:t184256/nix-on-droid;
      inputs = {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
      };
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

  };
}
