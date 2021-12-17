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
    jq

    # System monitor
    htop
    pstree
    sysstat
  ];

  programs.home-manager = {
    enable = true;
    path = "…";
  };

  # systemd.user.sessionVariables ={
  #   NIX_PATH = "$NIX_PATH";
  # };
  home.file.".config/nix/nix.conf".source = ./nix.conf;
}
