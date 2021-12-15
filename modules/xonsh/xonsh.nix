{ config, pkgs, ... }:
{
  # Broken
  home.packages = with pkgs; [
    xonsh
    (python39.withPackages (ps: with ps; [
      requests
    ]))
  ];

  home.file.".xonshrc".source = ./xonshrc;
}
