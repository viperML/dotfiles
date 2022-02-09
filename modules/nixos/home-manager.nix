{ config
, pkgs
, lib
, inputs
, ...
}:
{
  # Special setting to Home-Manager if it runs as a NixOS module
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = { inherit inputs; };
    sharedModules = [
      {
        home.stateVersion = lib.mkForce config.system.stateVersion;
      }
    ];
  };
}
