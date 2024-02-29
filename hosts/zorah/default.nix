{ config
, withSystem
, mkNixos
, inputs
, ...
}:
let
  system = "x86_64-linux";
  inherit (config.flake) nixosModules homeModules;
in
{
  flake.nixosConfigurations.zorah = withSystem system ({ pkgs, ... }:
    mkNixos system [
      #-- Host-specific
      ./configuration.nix
      ./hardware.nix
      inputs.lanzaboote.nixosModules.lanzaboote
      nixosModules.user-ayats
      # (import ../../modules/nixos/_mkUser.nix {name = "alice"; uid = 1010;})
      # {
      #   users.users.alice = {
      #     password = "1234"
      #   };
      # }

      {
        home-manager.sharedModules = [
          ./home.nix
          homeModules.browser

          # homeModules.emacs
          homeModules.guix
          homeModules.emacs-doom
        ];
      }

      #-- Environment
      # {services.xserver.displayManager.autoLogin.user = "ayats";}
      # nixosModules.sway
      # nixosModules.hyprland
      # nixosModules.plasma5
      # nixosModules.gnome
      nixosModules.plasma6

      #-- Other
      nixosModules.tailscale
      nixosModules.guix
      nixosModules.yubikey
      nixosModules.printing
      nixosModules.tpm2
      nixosModules.swapfile
    ]);
}
