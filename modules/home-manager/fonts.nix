{
  config,
  pkgs,
  ...
}:
{
  fonts.fontconfig.enable = true;

  home.packages =
    with pkgs; [
      jetbrains-mono
      (
        pkgs.nerdfonts.override {
          fonts = [
            "JetBrainsMono"
            "VictorMono"
            "Inconsolata"
          ];
        }
      )
      roboto
      corefonts
      noto-fonts
      # noto-fonts-cjk
      noto-fonts-extra
      noto-fonts-emoji
    ];
}
