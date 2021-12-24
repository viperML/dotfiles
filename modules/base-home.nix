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

  home.file.".config/nix/nix.conf".source = ./nix.conf;
  home.file.".config/nixpkgs/config.nix".source = ./nixpkgs.conf;

  home.sessionVariables = lib.mkForce {
    NIX_PATH = "nixpkgs=$HOME/.nix-inputs/nixpkgs$\{NIX_PATH:+:$NIX_PATH}";
    FLAKE = "$HOME/.dotfiles";
  };

  home.activation.use-flake-channels = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    $DRY_RUN_CMD rm -rf $VERBOSE_ARG ~/.nix-defexpr
    $DRY_RUN_CMD ln -s $VERBOSE_ARG /dev/null $HOME/.nix-defexpr
    $DRY_RUN_CMD rm -rf $VERBOSE_ARG ~/.nix-channels
    $DRY_RUN_CMD ln -s $VERBOSE_ARG /dev/null $HOME/.nix-channels
  '';
}
