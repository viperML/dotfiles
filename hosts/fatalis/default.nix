{
  config,
  withSystem,
  mkNixos,
  inputs,
  ...
}: let
  system = "x86_64-linux";
  inherit (config.flake) nixosModules;
in {
  flake.nixosConfigurations.fatalis = withSystem system ({pkgs, ...}:
    mkNixos system [
      #-- Topology
      ./configuration.nix
      nixosModules.es
      inputs.lanzaboote.nixosModules.lanzaboote
      nixosModules.tmpfs
      nixosModules.tpm2
      nixosModules.user-ayats
      nixosModules.user-soch
      nixosModules.yubikey

      #-- Environment
      {services.displayManager.autoLogin.user = "ayats";}
      # nixosModules.plasma6
      nixosModules.gnome

      #-- Other
      nixosModules.tailscale
      nixosModules.guix
      # nixosModules.docker
      nixosModules.printing
      # nixosModules.incus
      nixosModules.podman
    ]);
}
