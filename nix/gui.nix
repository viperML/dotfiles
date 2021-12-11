{ config, pkgs, ... }:
{
  xdg = {
   enable = true;
   mime.enable=true;
  };

  targets.genericLinux.enable = true;

  home.extraProfileCommands = ''
  if [[ -d "$out/share/applications" ]] ; then
    ${pkgs.desktop-file-utils}/bin/update-desktop-database $out/share/applications
  fi
  '';

  home.packages = with packages; [
    
  ]
}
