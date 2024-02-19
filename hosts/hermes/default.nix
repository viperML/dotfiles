{ config
, withSystem
, mkNixos
, ...
}:
let
  system = "x86_64-linux";
  inherit (config.flake) nixosModules homeModules;
in
{
  flake.nixosConfigurations.hermes = withSystem system ({ pkgs, ... }:
    mkNixos system [
      #-- Host-specific
      ./configuration.nix
      ./hardware.nix
      nixosModules.user-ayats
      # nixosModules.user-soch

      {
        home-manager.sharedModules = [
          ./home.nix
          homeModules.browser
          # homeModules.emacs
        ];
      }

      #-- Environment
      { services.xserver.displayManager.autoLogin.user = "ayats"; }
      # nixosModules.sway
      # nixosModules.hyprland
      # nixosModules.plasma5
      nixosModules.gnome

      #-- Other
      # nixosModules.podman
      nixosModules.tailscale
      # nixosModules.docker
      # nixosModules.containerd
      # (args: {programs.nix-ld.package = args.packages.nix-ld.default;})

      # ./polkit.nix
    ]);
}
