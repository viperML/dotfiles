{ config, pkgs, inputs, lib, ... }:

{
  home.packages = with pkgs; [
    latte-dock
  ];


  # Latte dock config
  home.file.".config/latte/nix.layout.latte.backup".source = ./nix.layout.latte;

}
