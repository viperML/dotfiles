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

          allowUnfreePredicate =
            pkg:
            let
              pname = lib.getName pkg;
              byName = builtins.elem pname [
                "corefonts"
                "cnijfilter2"
                "drawio"
                "google-chrome"
                "hplip"
                "microsoft-edge"
                "nvidia-settings"
                "nvidia-x11"
                "samsung-UnifiedLinuxDriver"
                "slack"
                "steam"
                "steam-original"
                "steam-unwrapped"
                "vivaldi"
                "vscode"
              ];
              byLicense = builtins.elem pkg.meta.license.shortName [
                "CUDA EULA"
                "bsl11"
                "obsidian"
              ];
            in
            if byName || byLicense then lib.warn "Allowing unfree package: ${pname}" true else false;
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
              nix = flake.self.lib.versionGate pkgs.nixVersions.nix_2_26 pkgs.nix;
              nil = inputs'.nil.packages.default;

              # manual overrides to auto callPackage
              nix-index = callPackage ./nix-index {
                database = inputs'.nix-index-database.packages.nix-index-database;
                databaseDate = config.flake.lib.mkDate inputs.nix-index-database.lastModifiedDate;
              };
              # preventing infrec
              guix = callPackage ./guix {
                inherit (pkgs) guix;
              };
              yazi = callPackage ./yazi {inherit (pkgs) yazi;};
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

              am = inputs.activation-manager.lib.homeBundle {
                pkgs = (pkgs // self);
                modules = [ ../modules/activation-manager/main.nix ];
              };
            };
        in
        stage3
      );

      checks = {
        hover-rs = inputs'.hover-rs.packages.default;
      };
    };
}
