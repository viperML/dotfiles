inputs @ {self, ...}: let
  system = "x86_64-linux";

  # nixpkgs-src = self.lib.patch-nixpkgs {
  #   nixpkgs = inputs.nixpkgs;
  #   patches = [
  #     # rec {
  #     #   name = "172660";
  #     #   url = "https://github.com/NixOS/nixpkgs/pull/${name}.patch";
  #     #   sha256 = "sha256-VZyztFkJ8TZXamwQ0f2E8p7wnW1Z/UZI0vXu24r3WY0=";
  #     #   exclude = [];
  #     # }
  #   ];
  #   pkgs = self.legacyPackages.${system};
  # };

  nixpkgs-src = inputs.nixpkgs;

  pkgs = import nixpkgs-src {
    inherit system;
    config.allowUnfree = true;
  };

  inherit (pkgs) lib;

  nixosSystem = args: import "${nixpkgs-src}/nixos/lib/eval-config.nix" args;
  modulesPath = "${nixpkgs-src}/nixos/modules";
in
  self.lib.mkSystem rec {
    inherit system nixosSystem pkgs;
    specialArgs = {inherit self inputs;};
    specialisations = {
      "base" = {
        nixosModules = with self.nixosModules; [
          ./configuration.nix
          {
            viper.defaultSpec = "kde";
          }
          common
          mainUser-ayats
          inputs.nix-common.nixosModules.channels-to-flakes
          inputs.home-manager.nixosModules.home-manager
          desktop
          keyring

          virt
          # docker
          podman
          printing
          ld
          flatpak

          # Experiments
          ./fix-bluetooth.nix
        ];
        homeModules = with self.homeModules; [
          ./home.nix
          common
          inputs.nix-common.homeModules.channels-to-flakes
          gui
          git
          vscode
          wezterm
          nh
          flatpak

          # inputs.nix-doom-emacs.hmModule
          # emacs-doom
        ];
      };
      "kde" = {
        nixosModules =
          self.specialisations.kde.nixosModules
          ++ self.specialisations.nvidia.nixosModules;
        inherit (self.specialisations.kde) homeModules;
      };
    };
  }
