{
  lib,
  config,
  inputs,
  ...
}:
{
  flake.pkgsFor =
    pkgs:
    (lib.fix (
      self:
      let
        inherit (pkgs) system;
        combined = (pkgs // self);
        callPackage = lib.callPackageWith combined;

        auto = lib.pipe (builtins.readDir ./.) [
          (lib.filterAttrs (name: value: value == "directory"))
          (builtins.mapAttrs (name: _: callPackage ./${name} { }))
        ];

        wrappers = inputs.wrapper-manager.lib {
          pkgs = combined;
          modules = [
            #  ../wrappers/wezterm
            ../wrappers/helix
          ];
        };
      in
      auto
      // wrappers.config.build.packages
      // {
        any-nix-shell = callPackage ./any-nix-shell { inherit (pkgs) any-nix-shell; };
        nix-index = callPackage ./nix-index {
          database = inputs.nix-index-database.legacyPackages.${system}.database;
          databaseDate = config.flake.lib.mkDate inputs.nix-index-database.lastModifiedDate;
        };
      }
    ));

  perSystem =
    ps@{ pkgs, ... }:
    {
      packages = config.flake.pkgsFor pkgs;

      checks = { };
    };
}
