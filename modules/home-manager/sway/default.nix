args @ {
  config,
  pkgs,
  lib,
  packages,
  ...
}: {
  wayland.windowManager.sway = {
    enable = true;
    # Use NixOS module system to install
    package = null;
    systemdIntegration = true;
    inherit (import ./config.nix args) config extraConfig;
  };

  home.packages = [
    pkgs.qgnomeplatform
    pkgs.adwaita-qt
    pkgs.wofi
    pkgs.firefox

    pkgs.libsForQt5.dolphin
    pkgs.libsForQt5.ark
    pkgs.libsForQt5.qtwayland
    pkgs.libsForQt5.dolphin-plugins
    pkgs.libsForQt5.ffmpegthumbs
    pkgs.libsForQt5.kdegraphics-thumbnailers
    pkgs.libsForQt5.kio
    pkgs.libsForQt5.kio-extras
    pkgs.libsForQt5.gwenview

    packages.self.tym
  ];

  systemd.user.services = let
    mkService = lib.recursiveUpdate {
      Install.WantedBy = ["graphical-session.target"];
    };
  in  {
    mako = mkService {
      Unit.Description = "Notification daemon";
      Service.ExecStart = "${pkgs.mako}/bin/mako";
    };

    gammastep = mkService {
      Unit.Description = "Night time color filter";
      Service.ExecStart = "${pkgs.gammastep}/bin/gammastep -m wayland -l 40:-2 -t 6500:3000";
    };

    avizo = mkService {
      Unit.Description = "Volume popup daemon";
      Service.ExecStart = "${pkgs.avizo}/bin/avizo-service";
    };

    waybar = mkService {
      Unit.Description = "System bar";
      Service.ExecStart = "${pkgs.waybar}/bin/waybar";
    };

    wallpaper = mkService {
      Unit.Description = "Wallpaper daemon";
      Service.ExecStart = "${pkgs.swaybg}/bin/swaybg --color '#121212'";
    };
  };

  xdg.configFile."avizo/config.ini".source = ./avizo.ini;
}
