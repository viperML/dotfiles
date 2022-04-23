{
  self,
  inputs,
}: let
  system = "x86_64-linux";

  nixpkgs-src = self.lib.patch-nixpkgs {
    nixpkgs = inputs.nixpkgs;
    PRS = [
      rec {
        PR = "168269";
        url = "https://github.com/NixOS/nixpkgs/pull/${PR}.patch";
        sha256 = "sha256-ptJ6P7qqN78FeS/v1qST8Ut99WyI4tRCnPv+aO/dAOQ=";
        exclude = [];
      }
    ];
    pkgs = self.legacyPackages.${system};
  };

  nixosSystem = args: import "${nixpkgs-src}/nixos/lib/eval-config.nix" args;
  # nixosSystem = inputs.nixpkgs.lib.nixosSystem;

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
          # ./systemd-boot.nix
          common
          mainUser-ayats

          inputs.nixos-flakes.nixosModules.channels-to-flakes
          inputs.home-manager.nixosModules.home-manager
          desktop
          gnome-keyring
          dram

          virt
          docker
          printing
          gaming
          ld
          index
          flatpak
        ];
        homeModules = with self.homeModules; [
          ./home.nix
          common
          inputs.nixos-flakes.homeModules.channels-to-flakes
          gui
          git
          bat
          fish
          lsd
          neofetch
          neovim
          vscode
          # firefox
          starship
          wezterm
          nh
          xonsh
          # emacs
          # wine
          # inputs.nix-doom-emacs.hmModule
          # emacs-doom
        ];
      };
      inherit
        (self.specialisations)
        gnome
        kde
        ;
    };
  }
