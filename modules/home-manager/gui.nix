{
  config,
  pkgs,
  packages,
  ...
}: {
  xdg = {
    enable = true;
    mime.enable = true;
  };

  fonts.fontconfig.enable = true;

  home.packages = with pkgs; [
    # Autostart
    flameshot
    # Misc
    syncthing

    # Fonts
    (pkgs.nerdfonts.override {
      fonts = [
        "JetBrainsMono"
      ];
    })
    corefonts
    noto-fonts
    noto-fonts-extra
    noto-fonts-emoji
    noto-fonts-cjk

    roboto
  ];
}
