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


  # Use flake nixpkgs instead of channels:

  # A standard Nix install will set legacy nix-channels
  # nix-channel --list
  #   nixpkgs https://...
  # These channels are defined in ~/.nix-channels and ~/.nix-defexpr

  # They are also automatically created by home-manager
  # When they exist, they are automatically put into $NIX_PATH (no option to choose)

  # Solution? Nuke them (link to /dev/null)
  # Then put the channels coming from out flake inputs into a sensible location (~/.nix-inputs)
  # Finally, insert them at $NIX_PATH

  home.file = lib.mapAttrs' (name: value: { name = ".nix-inputs/${name}"; value = { source = value.outPath; }; }) inputs;
  home.sessionVariables = lib.mkForce {
    NIX_PATH = "nixpkgs=$HOME/.nix-inputs/nixpkgs$\{NIX_PATH:+:$NIX_PATH}";
    FLAKE = "$HOME/.dotfiles";
  };

  home.activation.useFlakeChannels = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    $DRY_RUN_CMD rm -rf $VERBOSE_ARG ~/.nix-defexpr
    $DRY_RUN_CMD ln -s $VERBOSE_ARG /dev/null $HOME/.nix-defexpr
    $DRY_RUN_CMD rm -rf $VERBOSE_ARG ~/.nix-channels
    $DRY_RUN_CMD ln -s $VERBOSE_ARG /dev/null $HOME/.nix-channels
  '';
}
