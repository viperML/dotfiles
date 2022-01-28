{ config, pkgs, ... }:

{
  xdg = {
    enable = true;
    mime.enable = true;

    configFile = {
      "autostart/Mailspring.desktop".text = ''
        [Desktop Action NewMessage]
        Exec=${pkgs.mailspring}/bin/mailspring mailto:
        Name[en_US]=New Message
        Name=New Message

        [Desktop Entry]
        Actions=NewMessage
        Categories=GNOME;GTK;Network;Email;
        Comment=The best email app for people and teams at work
        Exec=${pkgs.mailspring}/bin/mailspring %U --background
        GenericName=Mail Client
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
    };

  };

  # targets.genericLinux.enable = true;

  home.packages = with pkgs; [
    # Autostart
    flameshot
    mailspring

    # Misc
    google-chrome
  ];

}
