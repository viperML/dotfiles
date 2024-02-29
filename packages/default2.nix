{
  self,
  inputs,
  lib,
  ...
}:
{
  perSystem =
    { system, pkgs, ... }:
    let
      callPackage = lib.callPackageWith (
        pkgs // { packages = inputs.nix-common.lib.mkPackages system inputs; }
      );
    in
    {
      packages = {
        hpc = callPackage ./hpc.nix {};
      };
    };
}
