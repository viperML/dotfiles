{ config, pkgs, ... }:
{
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
}
