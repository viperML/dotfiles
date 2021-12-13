{ config, pkgs, ... }:
{
  xdg = {
   enable = true;
   mime.enable=true;
  };

  targets.genericLinux.enable = true;

  home.packages = with pkgs; [
    discord
  ];
}
