{ config, pkgs, ... }:
{
  fonts.fontconfig.enable = true;

  home.packages = with pkgs; [
    jetbrains-mono
    roboto
    (pkgs.nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
  ];
}
