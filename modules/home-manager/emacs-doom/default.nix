{
  pkgs,
  inputs,
  config,
  ...
}:
{
  # programs.emacs = {
  #   enable = true;
  #   # package = pkgs.emacsWithPackagesFromUsePackage {
  #   #   config = ./init.el;
  #   #   alwaysEnsure = true;
  #   #   package = pkgs.emacs;
  #   # };
  # };
  services.emacs = {
    enable = true;
    socketActivation.enable = true;
    client  = {
      enable = true;
    };
  };

  home.packages = with pkgs; [
    emacs-all-the-icons-fonts
    fd
    ripgrep
  ];

  # xdg.configFile."emacs" = {
  #   source = (pkgs.callPackages ./generated.nix {}).doomemacs.src;
  #   recursive = true;
  # };

  xdg.configFile."doom".source = config.lib.file.mkOutOfStoreSymlink "${config.unsafeFlakePath}/modules/home-manager/emacs-doom";
}
