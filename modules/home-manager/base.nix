{ config, pkgs, lib, ... }:

{
  # Generic programs
  home.packages = with pkgs; [
    # Nix management
    nixUnstable
    nix-prefetch-scripts
    update-nix-fetchgit
    fup-repl
    cachix

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

  home.file.".config/nix/nix.conf".source = ../nix.conf;
  home.file.".config/nixpkgs/config.nix".source = ../nixpkgs.conf;

  home.file.".config/libvirt/libvirtd.conf".text = "uri_default = \"qemu:///system\"";

}
