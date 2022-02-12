{ config
, pkgs
, ...
}:
let
  launch-mailspring = pkgs.writeShellScriptBin "launch-mailspring" ''
    sleep 3
    ${pkgs.mailspring}/bin/mailspring --background
  '';
in
{
  xdg = {
    enable = true;
    mime.enable = true;

    configFile = {
      "autostart/Mailspring.desktop".text = ''
        [Desktop Action NewMessage]
        Exec=mailspring mailto:
        Name[en_US]=New Message
        Name=New Message

        [Desktop Entry]
        Actions=NewMessage
        Categories=GNOME;GTK;Network;Email;
        Comment=The best email app for people and teams at work
        Exec=${launch-mailspring}/bin/launch-mailspring
        Icon=mailspring
        Keywords=email;internet;
        MimeType=x-scheme-handler/mailto;x-scheme-handler/mailspring;
        Name=Mailspring
        StartupNotify=true
        StartupWMClass=Mailspring
        Type=Application
      '';

      "autostart/org.flameshot.Flameshot.desktop".text = ''
        [Desktop Action Capture]
        Exec=${pkgs.flameshot}/bin/flameshot gui --delay 500
        Name=Take screenshot

        [Desktop Action Configure]
        Exec=${pkgs.flameshot}/bin/flameshot config
        Name=Configure

        [Desktop Action Launcher]
        Exec=${pkgs.flameshot}/bin/flameshot launcher
        Name=Open launcher

        [Desktop Entry]
        Actions=Configure;Capture;Launcher;
        Categories=Graphics;
        Comment=Powerful yet simple to use screenshot software.
        Exec=${pkgs.flameshot}/bin/flameshot
        GenericName=Screenshot tool
        Icon=org.flameshot.Flameshot
        Keywords=flameshot;screenshot;capture;shutter;
        Name=Flameshot
        StartupNotify=false
        Terminal=false
        Type=Application
        X-DBUS-ServiceName=org.flameshot.Flameshot
        X-DBUS-StartupType=Unique
        X-KDE-DBUS-Restricted-Interfaces=org.kde.kwin.Screenshot
      '';

      "autostart/caffeine.desktop".text = ''
        [Desktop Entry]
        Categories=Utility;TrayIcon;DesktopUtility
        Comment[en_US]=Temporarily deactivate the screensaver and sleep mode
        Comment=Temporarily deactivate the screensaver and sleep mode
        Encoding=UTF-8
        Exec=bash -c "sleep 3; ${pkgs.caffeine-ng}/bin/caffeine"
        GenericName[en_US]=
        GenericName=
        Icon=caffeine
        Keywords=Screensaver,Power,DPMS,Blank,Idle
        MimeType=
        Name[en_US]=Caffeine-ng
        Name=Caffeine-ng
        Path=
        StartupNotify=false
        Terminal=false
        TerminalOptions=
        Type=Application
        X-DBUS-ServiceName=
        X-DBUS-StartupType=
        X-KDE-SubstituteUID=false
        X-KDE-Username=
      '';
    };
  };

  # targets.genericLinux.enable = true;

  home.packages =
    with pkgs;
    [
      # Autostart
      flameshot
      mailspring
      caffeine-ng

      # Misc
      google-chrome
    ];
}
