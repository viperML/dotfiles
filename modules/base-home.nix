# home-manager module
args @ { config, pkgs, lib, inputs, ... }:

{
  # Generic programs
  home.packages = with pkgs; [
    # Nix management
    nixFlakes
    nix-index
    nix-prefetch-scripts
    update-nix-fetchgit
    nixpkgs-fmt
    nur.repos.xe.comma
    nix-bundle
    rnix-lsp
    fup-repl
    # nix-index

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

  # https://github.com/nix-community/home-manager/blob/master/modules/targets/generic-linux.nix
  # genericLinux is useful, but sets up channels which will be done using this flake
  # so I override NIX_PATH
  targets.genericLinux.enable = true;
  # systemd.user.sessionVariables = lib.mkForce {
  #   NIX_PATH = "$NIX_PATH";
  # };

  # xdg.configFile."nix-test".source = "${args}";

}
