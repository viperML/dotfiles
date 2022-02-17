{
  flake-utils-plus,
  lib,
  ...
}:
let
  nixosModules = flake-utils-plus.lib.exportModules (
    lib.mapAttrsToList (name: value: ./nixos/${name}) (builtins.readDir ./nixos)
  );
  homeModules = flake-utils-plus.lib.exportModules (
    lib.mapAttrsToList (name: value: ./home-manager/${name}) (builtins.readDir ./home-manager)
  );
in { inherit nixosModules homeModules; }
