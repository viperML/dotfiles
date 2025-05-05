{
  config,
  withSystem,
  mkNixos,
  inputs,
  ...
}:
let
  system = "x86_64-linux";
  inherit (config.flake) nixosModules;
in
{
  flake.nixosConfigurations.zorah = withSystem system (
    { pkgs, ... }:
    mkNixos system [
      #-- Topology
      ./configuration.nix
      ./novidia.nix
      # {
      #   specialisation.cosmic = {
      #     inheritParentConfig = true;
      #     configuration = {
      #       environment.etc."specialisation".text = "cosmic";
      #       # disabledModules = [nixosModules.gnome];
      #       services.desktopManager.cosmic.enable = true;
      #     };
      #   };
      # }
      inputs.lanzaboote.nixosModules.lanzaboote
      nixosModules.printing
      nixosModules.tmpfs
      nixosModules.tpm2
      nixosModules.user-ayats
      nixosModules.user-soch
      nixosModules.yubikey
      nixosModules.silent-boot

      #-- Environment
      # {services.displayManager.autoLogin.user = "ayats";}
      ../../modules/nixos/hyprland.nix
      {
        specialisation.gnome = {
          inheritParentConfig = true;
          configuration = {
            environment.etc."specialisation".text = "gnome";
            disabledModules = [
              ../../modules/nixos/hyprland.nix
            ];
            imports = [
              ../../modules/nixos/gnome.nix

            ];
          };
        };
      }

      #-- Other
      nixosModules.tailscale
      nixosModules.guix
      # nixosModules.docker
      # nixosModules.incus
      nixosModules.podman
      nixosModules.ddc
    ]
  );
}
