{ config, pkgs, ... }:

{
  xdg = {
    enable = true;
    mime.enable = true;

    configFile."autostart/Mailspring.desktop" = {
      text = ''
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
    };

  };

  # targets.genericLinux.enable = true;

  home.packages = with pkgs; [
    discord
    mailspring
  ];

}
