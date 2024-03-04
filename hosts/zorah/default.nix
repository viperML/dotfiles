{
  config,
  withSystem,
  mkNixos,
  inputs,
  ...
}:
let
  system = "x86_64-linux";
  inherit (config.flake) nixosModules homeModules;
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
      nixosModules.yubikey

      #-- home-manager
      {
        home-manager.sharedModules = [
          ./home.nix
          homeModules.browser
          homeModules.emacs-doom
        ];
      }

      #-- Environment
      { services.xserver.displayManager.autoLogin.user = "ayats"; }
      nixosModules.plasma6

      #-- Other
      nixosModules.tailscale
      nixosModules.guix
    ]
  );
}
