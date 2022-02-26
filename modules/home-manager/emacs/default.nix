{
  config,
  pkgs,
  inputs,
  ...
}: {
  programs.emacs = {
    enable = true;
    package = pkgs.emacsWithPackagesFromUsePackage {
      config = ./emacs.el;
      alwaysEnsure = true;
    };
  };
}
