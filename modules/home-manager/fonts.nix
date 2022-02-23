{
  config,
  pkgs,
  ...
}: let
  my-nerdfonts = pkgs.nerdfonts.override {
    fonts = [
      "JetBrainsMono"
      "Hack"
    ];
  };
in {
  fonts.fontconfig.enable = true;

  home.packages = builtins.attrValues {
    inherit
      (pkgs)
      # jetbrains-mono
      # roboto
      corefonts
      noto-fonts
      # noto-fonts-cjk
      noto-fonts-extra
      noto-fonts-emoji
      san-francisco
      libertinus
      ;

    inherit my-nerdfonts;
  };
}
