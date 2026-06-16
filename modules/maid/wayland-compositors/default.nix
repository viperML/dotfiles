{ pkgs, lib, ... }:
let
  targets = [ "graphical-session.target" ];

  mkService =
    cfg:
    lib.mkMerge [
      {
        wantedBy = targets;
        partOf = targets;
        after = targets;
      }
      cfg
    ];
in
{
  imports = [
    ../noctalia
  ];

  systemd.services = {
    wl-clip-persist = mkService {
      description = "Wayland clipboard persistence daemon";
      serviceConfig = {
        ExecStart = "${lib.getExe pkgs.wl-clip-persist} --clipboard regular";
        Restart = "on-failure";
      };
    };
  };

  dconf.settings = {
    "/org/gnome/desktop/interface/color-scheme" = "prefer-dark";
    "/org/gnome/desktop/interface/cursor-size" = 24;
    "/org/gnome/desktop/interface/cursor-theme" = "DMZ-White";
    "/org/gnome/desktop/interface/document-font-name" = "Inter 11";
    "/org/gnome/desktop/interface/enable-hot-corners" = false;
    "/org/gnome/desktop/interface/font-name" = "Inter 11";
    "/org/gnome/desktop/interface/gtk-enable-primary-paste" = false;
    "/org/gnome/desktop/interface/gtk-theme" = "adw-gtk3-dark";
    "/org/gnome/desktop/interface/icon-theme" = "Adwaita";
    "/org/gnome/desktop/interface/monospace-font-name" = "Iosevka Fixed Medium 11";
    "/org/gnome/desktop/interface/show-battery-percentage" = true;
  };
}
