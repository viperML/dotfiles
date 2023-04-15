{
  pkgs,
  inputs,
  config,
  ...
}: let
  epkgs = pkgs.extend inputs.emacs-overlay.overlays.default;
in {
  programs.emacs = {
    enable = true;
    package = epkgs.emacsWithPackagesFromUsePackage {
      config = ./init.el;
      alwaysEnsure = true;
      package = epkgs.emacsPgtk;
    };
  };

  home.packages = with epkgs; [
    emacs-all-the-icons-fonts
  ];

  systemd.user.tmpfiles.rules = [
    "L+ ${config.home.homeDirectory}/.emacs.d - - - - ${config.unsafeFlakePath}/modules/home-manager/emacs"
  ];
}
