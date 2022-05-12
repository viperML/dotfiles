inputs @ {self, ...}: let
  system = "x86_64-linux";

  nixpkgs-src = self.lib.patch-nixpkgs {
    nixpkgs = inputs.nixpkgs;
    patches = [
      # rec {
      #   name = "172660";
      #   url = "https://github.com/NixOS/nixpkgs/pull/${name}.patch";
      #   sha256 = "sha256-VZyztFkJ8TZXamwQ0f2E8p7wnW1Z/UZI0vXu24r3WY0=";
      #   exclude = [];
      # }
    ];
    pkgs = self.legacyPackages.${system};
  };

  # nixpkgs-src = inputs.nixpkgs;
  pkgs = import nixpkgs-src {
    inherit system;
    config.allowUnfree = true;
  };

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
          inputs.nixos-flakes.nixosModules.channels-to-flakes
          inputs.home-manager.nixosModules.home-manager
          desktop
          gnome-keyring

          virt
          docker
          printing
          ld
          index
          # flatpak

          # Experiments
          ./fix-bluetooth.nix
          {
            boot.initrd.systemd = {
              enable = true;
              emergencyAccess = true;
            };
          }
        ];
        homeModules = with self.homeModules; [
          ./home.nix
          common
          inputs.nixos-flakes.homeModules.channels-to-flakes
          gui
          git
          shell
          neovim
          vscode
          wezterm
          nh
        ];
      };
      inherit
        (self.specialisations)
        kde
        ;
      # "kde-open" = {
      #   nixosModules =
      #     self.specialisations.kde.nixosModules
      #     ++ [
      #       {
      #         hardware.nvidia.open = true;
      #       }
      #     ];
      #   homeModules = self.specialisations.kde.homeModules;
      # };
    };
  }
