{ config, pkgs, lib, ... }:

{
  home.packages = with pkgs; [
    syncthingtray
    syncthing
  ];

  home.file.".config/autostart/syncthingtray.desktop".text = ''
    [Desktop Action open-webui]
    Exec=syncthingtray --webui
    Name=Open web UI

    [Desktop Entry]
    Categories=Network
    Comment[en_US]=Tray application for Syncthing
    Comment=Tray application for Syncthing
    Exec=syncthingtray --wait
    GenericName[en_US]=Syncthing Tray
    GenericName=Syncthing Tray
    Icon=syncthingtray
    MimeType=
    Name[en_US]=Syncthing Tray
    Name=Syncthing Tray
    Path=
    StartupNotify=true
    Terminal=false
    TerminalOptions=
    Type=Application
    X-DBUS-ServiceName=
    X-DBUS-StartupType=unique
    X-KDE-SubstituteUID=false
    X-KDE-Username=
  '';
}
