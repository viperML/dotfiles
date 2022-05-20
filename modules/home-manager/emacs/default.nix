{
  pkgs,
  config,
  lib,
  self,
  inputs,
  ...
}: let
  selfPath =
    if lib.hasAttr "FLAKE" config.home.sessionVariables
    then "${config.home.sessionVariables.FLAKE}/modules/home-manager/emacs"
    else "${self.outPath}/modules/home-manager/emacs";

  epkgs = import inputs.nixpkgs {
    inherit (pkgs) system;
    overlays = [
      inputs.emacs-overlay.overlay
    ];
  };
in {
  programs.emacs = {
    enable = true;
    package = epkgs.emacsWithPackagesFromUsePackage {
      config = ./init.el;
      alwaysEnsure = true;
      package = epkgs.emacsPgtkNativeComp;
    };
  };

  home.packages = with epkgs; [
    emacs-all-the-icons-fonts
  ];

  # home.file.".emacs.d".target = selfPath;

  systemd.user.tmpfiles.rules = [
    "L+ ${config.home.homeDirectory}/.emacs.d - - - - ${selfPath}"
  ];
}
