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
      #   specialisation.nvidia = {
      #     inheritParentConfig = true;
      #     configuration = {
      #       environment.etc."specialisation".text = "nvidia";
      #       imports = [ ./nvidia.nix ];
      #       disabledModules = [ ./novidia.nix ];
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

      #-- Environment
      # {services.displayManager.autoLogin.user = "ayats";}
      nixosModules.gnome

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
