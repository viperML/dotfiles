{
  config,
  pkgs,
  lib,
  inputs,
  self,
  ...
}:
{
  # Special setting to Home-Manager if it runs as a NixOS module
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = { inherit inputs self; };
    sharedModules = [
      {
        home.stateVersion = lib.mkForce config.system.stateVersion;
      }
    ];
  };
}
