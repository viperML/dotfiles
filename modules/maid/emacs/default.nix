{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.emacs;

  nv = pkgs.callPackages ./_sources/generated.nix {};

  myLib = import ../../../misc/lib { inherit lib; };
  inherit (myLib) versionGate;
in
{
  options.emacs = {
    package = (lib.mkPackageOption pkgs "emacs" { });
  };

  config = {
    emacs.package = pkgs.emacsWithPackagesFromUsePackage {
      # package = pkgs.emacs-pgtk;
      package = versionGate pkgs.emacs31-pgtk pkgs.emacs-pgtk;
      config = ./post-init.el;
      defaultInitFile = false;
      alwaysEnsure = true;
      extraEmacsPackages = epkgs: [
        # epkgs.treesit-grammars.with-all-grammars
      ];
      override = epkgs: epkgs // {
        project-x = epkgs.melpaBuild {
          pname = "projext-x";
          version = nv.project_x.date;
          src = nv.project_x.src;
          commit = nv.project_x.version;
        };
      };
    };

    packages = [
      cfg.package
    ];

    file.xdg_config.emacs.source = builtins.toString ./.;

    systemd.tmpfiles.dynamicRules = [
      "R {{home}}/.emacs.d - - - - -"
    ];
  };
}
