{
  lib,
  config,
  inputs,
  ...
}:
{
  flake.pkgsFor =
    prev:
    (lib.fix (
      self:
      let
        inherit (prev) system;
        final = (
          prev
          // self
        );
        callPackage = lib.callPackageWith final;

        auto = lib.pipe (builtins.readDir ./.) [
          (lib.filterAttrs (name: value: value == "directory"))
          (builtins.mapAttrs (name: _: callPackage ./${name} { }))
        ];

        wrappers = inputs.wrapper-manager.lib {
          pkgs = final;
          modules = [ ../wrappers/wezterm ];
        };
      in
      auto
      // {
        any-nix-shell = callPackage ./any-nix-shell { inherit (prev) any-nix-shell; };
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
