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
  flake.nixosConfigurations.hermes = withSystem system (
    { pkgs, ... }:
    mkNixos system [
      #-- Topology
      ./configuration.nix
      inputs.lanzaboote.nixosModules.lanzaboote
      nixosModules.tmpfs
      nixosModules.tpm2
      nixosModules.user-ayats
      nixosModules.user-soch
      nixosModules.yubikey

      #-- Environment
      { services.displayManager.autoLogin.user = "ayats"; }
      nixosModules.plasma6

      #-- Other
      # nixosModules.guix
      nixosModules.tailscale
      # nixosModules.docker
      # nixosModules.incus
      nixosModules.podman
      nixosModules.silent-boot
    ]
  );
}
