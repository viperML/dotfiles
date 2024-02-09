{
  pkgs,
  inputs,
  config,
  ...
}:
{
  programs.emacs = {
    enable = true;
  };

  home.packages = with pkgs; [
    emacs-all-the-icons-fonts
    fd
    ripgrep
  ];

  xdg.configFile."doom".source = config.lib.file.mkOutOfStoreSymlink "${config.unsafeFlakePath}/modules/home-manager/emacs-doom";
}
