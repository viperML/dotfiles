{ config, pkgs, ... }:

{
  home.username = "ayats";
  home.homeDirectory = "/home/ayats";

  # Generic programs
  home.packages = with pkgs; [
    nix-prefetch-scripts
    ripgrep
    fd
    tealdeer
    cpufetch
    onefetch
    neofetch
  ];


  programs.home-manager = {
    enable = true;
    path = "…";
  };
}
