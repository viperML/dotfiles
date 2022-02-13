{ config
, pkgs
, lib
, inputs
, ...
}:
let
  inherit (pkgs) system;
in
{
  # Generic programs
  home.packages =
    with pkgs; [
      # Nix management
      nix-prefetch-scripts
      update-nix-fetchgit
      fup-repl
      cachix
      nix-du

      inputs.alejandra.defaultPackage.${system}
      statix

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

  home.stateVersion = "21.11";

  programs.home-manager = {
    enable = true;
    path = "…";
  };

  home.file.".config/nix/nix.conf".source = ../../misc/nix.conf;
  home.file.".config/nixpkgs/config.nix".source = ../../misc/nixpkgs.nix;
}
