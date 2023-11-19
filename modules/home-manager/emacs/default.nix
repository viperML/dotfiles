{
  pkgs,
  inputs,
  config,
  ...
}:
{
  programs.emacs = {
    enable = true;
    package = pkgs.emacsWithPackagesFromUsePackage {
      config = ./init.el;
      alwaysEnsure = true;
      package = pkgs.emacs;
    };
  };

  home.packages = with pkgs; [
    emacs-all-the-icons-fonts
  ];

  systemd.user.tmpfiles.rules = [
    "L+ ${config.home.homeDirectory}/.emacs.d - - - - ${config.unsafeFlakePath}/modules/home-manager/emacs"
  ];
}
