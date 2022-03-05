{
  pkgs,
  config,
  lib,
  self,
  ...
}: let
  selfPath =
    if lib.hasAttr "FLAKE" config.home.sessionVariables
    then "${config.home.sessionVariables.FLAKE}/modules/home-manager/emacs"
    else "${self.outPath}/modules/home-manager/emacs";
in {
  programs.emacs = {
    enable = true;
    package = pkgs.emacsWithPackagesFromUsePackage {
      config = ./init.el;
      alwaysEnsure = true;
      package = pkgs.emacsPgtkGcc;
    };
  };

  home.packages = with pkgs; [
    emacs-all-the-icons-fonts
    rnix-lsp
  ];

  systemd.user.tmpfiles.rules = [
    "L+ ${config.home.homeDirectory}/.emacs.d - - - - ${selfPath}"
  ];
}
