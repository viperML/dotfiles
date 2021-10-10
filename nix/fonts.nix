{ config, pkgs, ... }:
{
  fonts.fontconfig.enable = true;
  home.packages = with pkgs; [
    jetbrains-mono
    (pkgs.nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
  ];
}
