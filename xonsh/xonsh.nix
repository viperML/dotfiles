{ config, pkgs, ... }:
{
  home.packages = with pkgs; [
    xonsh
  ];

  home.file.".xonshrc".source = ./xonshrc;
}
