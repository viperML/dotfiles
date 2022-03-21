# TODO move this to a standalone repo
{
  config,
  pkgs,
  inputs,
  self,
  lib,
  ...
}: let
  selfRegistry = {
    to = {
      path = self.outPath;
      type = "path";
    };
    from = {
      id = "self";
      type = "indirect";
    };
    exact = true;
  };
  inherit
    (lib)
    mapAttrs'
    nameValuePair
    ;
in {
  nix = {
    registry =
      {
        self = selfRegistry;
      }
      // lib.mapAttrs' (name: value: {
        inherit name;
        value.flake = value;
      })
      inputs;

    nixPath = [
      "nixpkgs=/etc/nix/inputs/self"
    ];
  };

  # environment.etc."nix/inputs/nixpkgs".source = self.outPath;
  environment.etc =
    mapAttrs' (n: v: nameValuePair "nix/inputs/${n}" {source = v.outPath;}) inputs;
  environment.variables.NIXPKGS_CONFIG = lib.mkForce "";
}
