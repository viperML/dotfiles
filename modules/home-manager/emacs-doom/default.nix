{
  config,
  pkgs,
  lib,
  self,
  ...
}: let
  selfPath =
    if lib.hasAttr "FLAKE" config.home.sessionVariables
    then "${config.home.sessionVariables.FLAKE}/modules/home-manager/emacs-doom"
    else "${self.outPath}/modules/home-manager/emacs-doom";

  emacsPath = "${config.home.homeDirectory}/.emacs.d";
in {
  programs.doom-emacs = {
    enable = true;
    doomPrivateDir = ./doom.d;
    emacsPackage = pkgs.emacsPgtkGcc;
    extraConfig = ''
      (load "~/.emacs.d/main.el")
      (setq custom-file "~/.emacs.d/custom.el")
      (load custom-file)
    '';
  };

  systemd.user.tmpfiles.rules = map (f: "L+ ${emacsPath}/${f} - - - - ${selfPath}/${f}") [
    "main.el"
    "custom.el"
  ];
}
