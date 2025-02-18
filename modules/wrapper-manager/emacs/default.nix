{ pkgs, ... }: let 
in
{
  wrappers.emacs = {
    basePackage = pkgs.emacsWithPackagesFromUsePackage {
      config = ./init.el;
      package = pkgs.emacs-pgtk;
      alwaysEnsure = true;
    };
    flags = [
      "--init-directory=${./.}"
    ];
  };
}
