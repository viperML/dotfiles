{ config, pkgs, ... }:
{
  targets.genericLinux.enable = true;
  # Generic programs
  home.packages = with pkgs; [
    # Nix management
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
