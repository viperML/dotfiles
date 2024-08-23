{
  pkgs,
  config,
  ...
}: {
  programs.emacs = {enable = true;};

  home.packages = with pkgs; [
    emacs-all-the-icons-fonts
    fd
    ripgrep
    parinfer-rust
  ];

  home.sessionPath = ["$HOME/.config/emacs/bin"];

  home.file = {
    ".emacs".source = config.lib.file.mkOutOfStoreSymlink "/var/empty/emacs";
    ".emacs.d".source = config.lib.file.mkOutOfStoreSymlink "/var/empty/emacs";
  };

  xdg.configFile."doom".source =
    config.lib.file.mkOutOfStoreSymlink
    "${config.unsafeFlakePath}/modules/home-manager/emacs-doom";
}
