{
  lib,
  config,
  inputs,
  ...
}:
{
  flake.pkgsFor =
    pkgs:
    let
      stage1 = (
        lib.fix (
          self:
          let
            inherit (pkgs) system;
            callPackage = lib.callPackageWith (pkgs // self);

            auto = lib.pipe (builtins.readDir ./.) [
              (lib.filterAttrs (name: value: value == "directory"))
              (builtins.mapAttrs (name: _: callPackage ./${name} { }))
            ];
          in
          auto
          // {
            nix-index = callPackage ./nix-index {
              database = inputs.nix-index-database.legacyPackages.${system}.database;
              databaseDate = config.flake.lib.mkDate inputs.nix-index-database.lastModifiedDate;
            };
          }
        )
      );
    in
    stage1
    // (inputs.wrapper-manager.lib {
      pkgs = pkgs // stage1;
      modules = lib.pipe (builtins.readDir ../modules/wrapper-manager) [
        (lib.filterAttrs (name: value: value == "directory"))
        builtins.attrNames
        (map (n: ../modules/wrapper-manager/${n}))
      ];
      # modules = [
      #   (builtins.readDir ../modules/wrapper-manager)
      #   #  ../wrappers/wezterm
      #   ../wrappers/helix
      # ];
    }).config.build.packages;

  perSystem =
    ps@{ pkgs, ... }:
    {
      packages = config.flake.pkgsFor pkgs;

      checks = { };
    };
}
