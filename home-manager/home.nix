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
    unar
    nixpkgs-fmt
    nur.repos.xe.comma
  ];


  programs.home-manager = {
    enable = true;
    path = "…";
  };
}
