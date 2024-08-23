{
  pkgs,
  inputs,
  config,
  ...
}: {
  programs.emacs = {
    enable = true;
    package = pkgs.emacsWithPackagesFromUsePackage {
      config = ./init.el;
      alwaysEnsure = true;
      package = pkgs.emacs;
    };
  };

  home.packages = with pkgs; [emacs-all-the-icons-fonts];

  xdg.configFile."emacs".source =
    config.lib.file.mkOutOfStoreSymlink
    "${config.unsafeFlakePath}/modules/home-manager/emacs";
}
