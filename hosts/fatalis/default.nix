{
  config,
  withSystem,
  mkNixos,
  inputs,
  ...
}: let
  system = "x86_64-linux";
  inherit (config.flake) nixosModules homeModules;
in {
  flake.nixosConfigurations.fatalis = withSystem system ({pkgs, ...}:
    mkNixos system [
      #-- Topology
      ./configuration.nix
      inputs.lanzaboote.nixosModules.lanzaboote
      nixosModules.tmpfs
      nixosModules.tpm2
      nixosModules.user-ayats
      nixosModules.yubikey

      #-- home-manager
      {
        home-manager.sharedModules = [./home.nix homeModules.browser];
      }

      #-- Environment
      {services.displayManager.autoLogin.user = "ayats";}
      nixosModules.plasma6

      #-- Other
      nixosModules.tailscale
      nixosModules.guix
      nixosModules.docker
      inputs.noshell.nixosModules.default
      {programs.noshell.enable = true;}
    ]);
}
