{
  config,
  withSystem,
  mkNixos,
  ...
}: let
  system = "x86_64-linux";
  inherit (config.flake) nixosModules homeModules;
in {
  flake.nixosConfigurations.fatalis = withSystem system ({pkgs, ...}:
    mkNixos system [
      #-- Host-specific
      ./configuration.nix
      ./hardware.nix
      nixosModules.user-ayats

      {
        home-manager.sharedModules = [
          ./home.nix
          homeModules.browser
        ];
      }

      #-- Environment
      {services.xserver.displayManager.autoLogin.user = "ayats";}
      # nixosModules.sway
      # nixosModules.hyprland
      # nixosModules.plasma5
      nixosModules.gnome

      #-- Other
      nixosModules.tailscale
    ]);
}
