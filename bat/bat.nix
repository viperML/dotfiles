{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    bat
  ];

  home.file.".confg/bat/config" = ./config;
}