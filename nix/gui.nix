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
    echo "Updating desktop database..."
  fi
  '';

  home.packages = with pkgs; [
    desktop-file-utils
    atom
  ];
}
