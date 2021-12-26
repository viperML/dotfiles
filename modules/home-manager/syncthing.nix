{ config, pkgs, lib, ... }:

{
  home.packages = with pkgs; [
    syncthingtray
    syncthing
  ];

  home.file.".config/autostart/syncthingtray.desktop".text = ''
    [Desktop Action open-webui]
    Exec=syncthingtray --webui --wait
    Name=Open web UI

    [Desktop Entry]
    Categories=Network
    Comment=Tray application for Syncthing
    Exec=syncthingtray
    GenericName=Syncthing Tray
    Icon=syncthingtray
    Name=Syncthing Tray
    Terminal=false
    Type=Application
  '';
}
