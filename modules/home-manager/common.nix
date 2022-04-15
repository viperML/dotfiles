{
  config,
  pkgs,
  lib,
  inputs,
  self,
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
    alejandra
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

  home.file.".config/nix/nix.conf".source = "${self.outPath}/misc/nix.conf";
}
