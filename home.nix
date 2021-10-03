{ config, pkgs, ... }:

{
  /* programs.home-manager.enable = true; */

  home.username = "ayats";
  home.homeDirectory = "/home/ayats";

  home.packages = [
    pkgs.fortune
  ];


  programs.home-manager = {
    enable = true;
    path = "…";
  };
}
