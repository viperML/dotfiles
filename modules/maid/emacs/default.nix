{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.emacs;

  nv = pkgs.callPackages ./_sources/generated.nix {};

  # readDir =
  #   root:
  #   builtins.readDir root
  #   |> builtins.mapAttrs (
  #     basename: type:
  #     let
  #       p = lib.path.append root basename;
  #     in
  #     if type == "regular" then
  #       p
  #     else if type == "directory" then
  #       readDir (p)
  #     else
  #       null
  #   )
  #   |> lib.attrsets.collect builtins.isPath
  #   |> builtins.filter (lib.hasSuffix ".el")
  #   |> map builtins.readFile
  #   |> builtins.concatStringsSep "\n";
in
{
  options.emacs = {
    package = (lib.mkPackageOption pkgs "emacs" { });
  };

  config = {
    emacs.package = pkgs.emacsWithPackagesFromUsePackage {
      package = pkgs.emacs-pgtk;
      # package = pkgs.emacs;
      config = ./post-init.el;
      defaultInitFile = false;
      alwaysEnsure = true;
      # extraEmacsPackages = epkgs: [
      #   epkgs.treesit-grammars.with-all-grammars
      # ];
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
