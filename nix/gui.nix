{ config, pkgs, ... }:
{
  xdg = {
   enable = true;
   mime.enable=true;
  };

  targets.genericLinux.enable = true;

  home.extraProfileCommands = ''
    ${pkgs.desktop-file-utils}/bin/update-desktop-database $out/share/applications
  '';

  home.packages = with pkgs; [
    desktop-file-utils
  ];
}
