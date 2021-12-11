{ config, pkgs, ... }:
{
  home.packages = with pkgs; [
    xonsh
    python3Packages.requests
  ];


  home.file.".xonshrc".source = ./xonshrc;
}
