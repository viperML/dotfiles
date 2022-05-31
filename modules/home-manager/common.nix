{
  config,
  pkgs,
  lib,
  inputs,
  self,
  packages,
  ...
}: {
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
    nix-tree

    # Editor support
    rnix-lsp
    packages.self.stylua

    # Misc utils
    android-tools
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

  xdg.configFile."nix/nix.conf".text = lib.fileContents "${self}/misc/nix.conf";
}
