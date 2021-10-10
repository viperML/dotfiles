{ config, pkgs, ... }:

{
  home.username = "ayats";
  home.homeDirectory = "/home/ayats";

    nixpkgs.config.packageOverrides = pkgs: {
    nur = import (builtins.fetchTarball "https://github.com/nix-community/NUR/archive/master.tar.gz") {
      inherit pkgs;
    };
  };

  environment.systemPackages = [ pkgs.nur.repos.xe.comma ];

  # Generic programs
  home.packages = with pkgs; [
    nix-prefetch-scripts
    ripgrep
    fd
    tealdeer
    unar
    nixpkgs-fmt
  ];


  programs.home-manager = {
    enable = true;
    path = "…";
  };
}
