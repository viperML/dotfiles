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
      inputs.lanzaboote.nixosModules.lanzaboote
      nixosModules.printing
      nixosModules.tmpfs
      nixosModules.tpm2
      nixosModules.user-ayats
      nixosModules.user-soch
      nixosModules.yubikey

      # inputs.nixos-hardware.nixosModules.common-gpu-nvidia-disable

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
