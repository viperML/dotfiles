{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.emacs;

  nv = pkgs.callPackages ./_sources/generated.nix { };

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
        epkgs.treesit-grammars.with-all-grammars
      ];
      override =
        epkgs:
        epkgs
        // {
          project-x = epkgs.melpaBuild {
            pname = "projext-x";
            version = nv.project_x.date;
            src = nv.project_x.src;
            commit = nv.project_x.version;
          };
          lsp-mode = epkgs.lsp-mode.overrideAttrs (old: {
            patches = (old.patches or [ ]) ++ [
              ./lsp-mode/0001-Simplify-elixir-ls-call.patch
            ];
            # src = pkgs.nix-gitignore.gitignoreSource [ ] /x/src/lsp-mode;
          });
        };
    };

    packages = [
      cfg.package
    ];

    file.xdg_config."emacs/post-init.el".source = builtins.toString ./post-init.el;
    file.xdg_config."emacs/pre-init.el".source = builtins.toString ./pre-init.el;
    file.xdg_config."emacs/pre-early-init.el".source = builtins.toString ./pre-early-init.el;
    file.xdg_config."emacs/post-early-init.el".source = builtins.toString ./post-early-init.el;
    file.xdg_config."emacs/init.el".source = "${nv.minimal-emacs-d.src}/init.el";
    file.xdg_config."emacs/early-init.el".source = "${nv.minimal-emacs-d.src}/early-init.el";

    systemd.tmpfiles.dynamicRules = [
      # "d {{xdg_config}}/emacs 0755 {{user}} {{group}} - -"
      "R {{home}}/.emacs.d - - - - -"
    ];
  };
}
