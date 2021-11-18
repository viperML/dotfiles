{ config, pkgs, ... }:
{
  # Generic programs
  home.packages = with pkgs; [
    # Nix management
    nix-prefetch-scripts
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
