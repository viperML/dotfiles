{
  config,
  pkgs,
  ...
}: {
  fonts.fontconfig.enable = true;

  home.packages = with pkgs; [
    # jetbrains-mono
    # roboto
    (pkgs.nerdfonts.override {
      fonts = [
        "JetBrainsMono"
        "Hack"
      ];
    })
    corefonts
    noto-fonts
    # noto-fonts-cjk
    noto-fonts-extra
    noto-fonts-emoji
    san-francisco
    libertinus
    roboto
  ];
}
