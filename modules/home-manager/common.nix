{
  config,
  pkgs,
  lib,
  inputs,
  packages,
  ...
}: let
  inherit (pkgs) system;
in {
  # Generic programs
  home.packages = with pkgs; [
    # Nix management
    nix-prefetch-scripts
    update-nix-fetchgit
    statix
    packages.alejandra.alejandra-x86_64-unknown-linux-gnu
    packages.nh.nh

    # Misc utils
    android-tools
    appimage-run
    choose
    dogdns
    fd
    htop
    hwloc
    jless
    jq
    lshw
    nmap
    pwgen
    ripgrep
    stylua
    sysstat
    tealdeer
    unar
  ];

  home.stateVersion = "21.11";

  home.file.".config/nix/nix.conf".source = ../../misc/nix.conf;
}
