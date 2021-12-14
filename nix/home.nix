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
    nix-bundle
    rnix-lsp
    # nix-index

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
