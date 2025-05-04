flake@{
  lib,
  config,
  inputs,
  ...
}:
{
  perSystem =
    {
      pkgs,
      system,
      inputs',
      ...
    }:
    {
      _module.args.pkgs = import inputs.nixpkgs {
        inherit system;

        overlays = [
          inputs.emacs-overlay.overlays.default
          (final: prev: {
            gnome-keyring = prev.gnome-keyring.overrideAttrs (old: {
              configureFlags = (lib.remove "--enable-ssh-agent" old.configureFlags) ++ [
                "--disable-ssh-agent"
              ];
            });
          })
        ];

        config = {
          allowInsecurePredicate =
            pkg:
            let
              pname = lib.getName pkg;
              byName = builtins.elem pname [
                "nix"
              ];
            in
            if byName then lib.warn "Allowing insecure package: ${pname}" true else false;

          allowUnfreePredicate = pkg: lib.warn "Allowing unfree package: ${lib.getName pkg}" true;
        };
      };

      packages = lib.fix (
        self:
        let
          # packages in $FLAKE/packages, callPackage'd automatically
          stage1 = lib.fix (
            self':
            let
              callPackage = lib.callPackageWith <| pkgs // self';

              auto = lib.pipe (builtins.readDir ./.) [
                (lib.filterAttrs (name: value: value == "directory"))
                (builtins.mapAttrs (name: _: callPackage ./${name} { }))
              ];
            in
            auto
            // {
              # nix = flake.self.lib.versionGate pkgs.nixVersions.nix_2_26 pkgs.nix;
              nix = pkgs.nix;
              nil = inputs'.nil.packages.default;

              # neovim-unchecked = inputs.mnw.lib.wrap pkgs (import ./neovim/module.nix pkgs);
              neovim-unchecked = inputs.mnw.lib.wrap pkgs { imports = [ ./neovim/module.nix ]; };
              neovim = self'.neovim-unchecked.overrideAttrs (old: {
                postInstall = ''
                  export HOME="$(mktemp -d)"
                  export NVIM_SILENT=1
                  $out/bin/nvim --headless '+lua =require("viper.health").loaded_exit()' '+q'
                '';
              });

              # manual overrides to auto callPackage
              nix-index = callPackage ./nix-index {
                database = inputs'.nix-index-database.packages.nix-index-database;
                databaseDate = config.flake.lib.mkDate inputs.nix-index-database.lastModifiedDate;
              };
              # preventing infrec
              guix = callPackage ./guix {
                inherit (pkgs) guix;
              };
              yazi = callPackage ./yazi { inherit (pkgs) yazi; };
            }
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
              specialArgs = {
                inherit inputs';
              };
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
              env = callPackage ./env {
                inherit inputs';
              };

              hpc-env = callPackage ./hpc-env { };
            };
        in
        stage3
      );

      checks = {
        hover-rs = inputs'.hover-rs.packages.default;
      };
    };
}
