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
    direnv
    nix-prefetch-scripts
    update-nix-fetchgit
    statix
    alejandra
    packages.self.nh
    packages.self.deploy-rs

    # Editor support
    rnix-lsp
    packages.self.stylua

    # Misc utils
    android-tools
    appimage-run
    dogdns
    fd
    htop
    jless
    jq
    ripgrep
    tealdeer
    unar
  ];

  home.stateVersion = "21.11";

  home.file.".config/nix/nix.conf".source = "${self.outPath}/misc/nix.conf";
}
