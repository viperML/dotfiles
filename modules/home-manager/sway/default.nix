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

  home.packages =
    lib.attrValues
    {
      inherit
        (pkgs)
        qgnomeplatform
        adwaita-qt
        wofi
        firefox
        ;
      inherit
        (pkgs.plasma5Packages)
        dolphin
        ark
        qtwayland
        dolphin-plugins
        ffmpegthumbs
        kdegraphics-thumbnailers
        kio
        kio-extras
        #

        gwenview
        ;
    };

  systemd.user.services = {
    mako = {
      Unit.Description = "Notification daemon";
      Service.ExecStart = "${pkgs.mako}/bin/mako";
      Install.WantedBy = ["sway-session.target"];
    };

    gammastep = {
      Unit.Description = "Night time color filter";
      Service.ExecStart = "${pkgs.gammastep}/bin/gammastep -m wayland -l 40:-2 -t 6500:3000";
      Install.WantedBy = ["sway-session.target"];
    };

    avizo = {
      Unit.Description = "Volume popup daemon";
      Service.ExecStart = "${pkgs.avizo}/bin/avizo-service";
      Install.WantedBy = ["sway-session.target"];
    };

    waybar = {
      Unit.Description = "System bar";
      Service.ExecStart = "${pkgs.waybar}/bin/waybar";
      Install.WantedBy = ["sway-session.target"];
    };
  };

  xdg.configFile."avizo/config.ini".source = ./avizo.ini;
}
