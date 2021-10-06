{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    bat
  ];

  home.file.".config/bat/config".source = ./config;
}