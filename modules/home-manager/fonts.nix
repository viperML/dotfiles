{
  config,
  pkgs,
  ...
}: {
  fonts.fontconfig.enable = true;

  home.packages = with pkgs; [
    (pkgs.nerdfonts.override {
      fonts = [
        "JetBrainsMono"
      ];
    })
    corefonts
    noto-fonts
    # noto-fonts-cjk
    noto-fonts-extra
    noto-fonts-emoji
    roboto
    #
    # hoefler-text
    etBook
    source-sans
    redaction
  ];
}
