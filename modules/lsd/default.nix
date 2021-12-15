{ config, pkgs, ... }:

{
  programs.lsd = {
    enable = true;
    enableAliases = false;
  };

  home.file.".config/lsd/config.yaml".source = ./config.yaml;
}
