{
  self,
  inputs,
}: let
  system = "x86_64-linux";

  # nixpkgs-src = self.lib.patch-nixpkgs {
  #   nixpkgs = inputs.nixpkgs;
  #   patches = [
  #     rec {
  #       name = "168269";
  #       url = "https://github.com/NixOS/nixpkgs/pull/${name}.patch";
  #       sha256 = "sha256-ptJ6P7qqN78FeS/v1qST8Ut99WyI4tRCnPv+aO/dAOQ=";
  #       exclude = [];
  #     }
  #   ];
  #   pkgs = self.legacyPackages.${system};
  # };

  nixpkgs-src = inputs.nixpkgs;

  nixosSystem = args: import "${nixpkgs-src}/nixos/lib/eval-config.nix" args;
  modulesPath = "${nixpkgs-src}/nixos/modules";
in
  self.lib.mkSystem rec {
    inherit system nixosSystem;
    pkgs = self.legacyPackages.${system};
    specialArgs = {inherit self inputs;};
    specialisations = {
      "base" = {
        nixosModules = with self.nixosModules; [
          ./configuration.nix
          common
          mainUser-ayats

          inputs.nixos-flakes.nixosModules.channels-to-flakes
          inputs.home-manager.nixosModules.home-manager
          desktop
          gnome-keyring

          virt
          docker
          printing
          gaming
          ld
          index
          flatpak
          ./fix-bluetooth.nix
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
    };
  }
