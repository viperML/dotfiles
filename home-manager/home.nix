{ config, pkgs, ... }:

{
  home.username = "ayats";
  home.homeDirectory = "/home/ayats";

  home.packages = with pkgs; [
    nix-prefetch-scripts
    lsd
    bat
    ripgrep
    fd
  ];


  programs.home-manager = {
    enable = true;
    path = "…";
  };
}
