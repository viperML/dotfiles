{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: let
  inherit (pkgs) system;
in {
  # Generic programs
  home.packages = with pkgs; [
    # Nix management
    nix-prefetch-scripts
    update-nix-fetchgit
    nix-du
    statix
    inputs.alejandra.defaultPackage.${system}
    inputs.nh.packages.${system}.nh
    # inputs.deploy-rs.packages.${system}.deploy-rs
    # Misc utils
    ripgrep
    fd
    tealdeer
    unar
    jq
    dogdns
    jless
    choose
    # bpytop
    # System monitor
    htop
    pstree
    sysstat
  ];

  home.stateVersion = "21.11";

  programs.home-manager = {
    enable = true;
    path = "…";
  };

  home.file.".config/nix/nix.conf".source = ../../misc/nix.conf;
  # home.file.".config/nixpkgs/config.nix".source = ../../misc/nixpkgs.nix;
}
