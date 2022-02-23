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
  home.packages =
    (builtins.attrValues {
      inherit
        (pkgs)
        # Nix management
        nix-prefetch-scripts
        update-nix-fetchgit
        cachix
        nix-du
        statix
        # Misc utils
        ripgrep
        fd
        tealdeer
        unar
        jq
        dogdns
        jless
        choose
        # System monitor
        htop
        pstree
        sysstat
        ;
    })
    ++ [
      inputs.alejandra.defaultPackage.${system}
      inputs.nh.packages.${system}.nh
      inputs.deploy-rs.packages.${system}.deploy-rs
    ];

  home.stateVersion = "21.11";

  programs.home-manager = {
    enable = true;
    path = "…";
  };

  home.file.".config/nix/nix.conf".source = ../../misc/nix.conf;
  # home.file.".config/nixpkgs/config.nix".source = ../../misc/nixpkgs.nix;
}
