{ pkgs, ... }:
{
  wrappers.emacs = {
    basePackage = pkgs.emacsWithPackagesFromUsePackage {
      config = ./emacs.el;
      package = pkgs.emacs-pgtk;
      alwaysEnsure = true;
    };
  };
}
