{
  lib,
  config,
  inputs,
  ...
}:
{
  flake.pkgsFor =
    pkgs:
    lib.fix (
      self:
      let
        # packages in $FLAKE/packages, callPackage'd automatically
        stage1 = (
          lib.fix (
            self':
            let
              inherit (pkgs) system;
              callPackage = lib.callPackageWith (pkgs // self');

              auto = lib.pipe (builtins.readDir ./.) [
                (lib.filterAttrs (name: value: value == "directory"))
                (builtins.mapAttrs (name: _: callPackage ./${name} { }))
              ];
            in
            auto
            // {
              # manual overrides to auto callPackage
              nix-index = callPackage ./nix-index {
                database = inputs.nix-index-database.legacyPackages.${system}.database;
                databaseDate = config.flake.lib.mkDate inputs.nix-index-database.lastModifiedDate;
              };
              fish = callPackage ./fish { inherit (pkgs) fish; };
            }
          )
        );

        # wrapper-manager packages
        stage2 =
          stage1
          // (inputs.wrapper-manager.lib {
            pkgs = pkgs // stage1;
            modules = lib.pipe (builtins.readDir ../modules/wrapper-manager) [
              (lib.filterAttrs (name: value: value == "directory"))
              builtins.attrNames
              (map (n: ../modules/wrapper-manager/${n}))
            ];
          }).config.build.packages;

        # packages that depend of wrappers
        stage3 =
          let
            callPackage = lib.callPackageWith (pkgs // self);
            callPackageScopedWith =
              autoArgs: f: args:
              let
                res = builtins.scopedImport (autoArgs // args) f;
                override = newArgs: callPackageScopedWith (autoArgs // newArgs) f;
              in
              res // { inherit override; };

            callPackageScoped = callPackageScopedWith (pkgs // self);
          in
          stage2
          // {
            # env = callPackageScoped ./env { };
            env = callPackage ./env { };
          };
      in
      stage3
    );

  perSystem =
    { pkgs, system, ... }:
    {
      _module.args.pkgs = import inputs.nixpkgs {
        inherit system;
        config = {
          allowUnfreePredicate =
            pkg:
            builtins.elem (lib.getName pkg) [
              "hplip"
              "samsung-UnifiedLinuxDriver"
              "cnijfilter2"
              "vscode"
              "steam-original"
              "vault"
            ];
        };
      };

      packages = config.flake.pkgsFor pkgs;

      checks = { };
    };
}
