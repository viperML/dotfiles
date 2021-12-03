{ config, pkgs, ... }:
{
  # Generic programs
  home.packages = with pkgs; [
    # Nix management
    nixFlakes
    nix-index
    nix-prefetch-scripts
    update-nix-fetchgit
    nixpkgs-fmt
    nur.repos.xe.comma

    # Misc utils
    ripgrep
    fd
    tealdeer
    unar

    # System monitor
    htop
    pstree
    sysstat
  ];
}
