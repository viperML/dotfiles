{ config, pkgs, lib, inputs, ... }:

{
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = { inherit inputs; };

    # If running in nixos, set the state version the same
    sharedModules = [
      {
        home.stateVersion = lib.mkForce config.system.stateVersion;
      }
    ];
  };
}
