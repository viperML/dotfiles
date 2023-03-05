{
  config,
  lib,
  pkgs,
  packages,
  ...
}: {
  xdg.configFile."wofi/style.css".source = ./wofi-style.css;
  xdg.configFile."wob/wob.ini".source = ./wob.ini;

  home.packages = [
    pkgs.wofi
  ];

  systemd.user.services = let
    mkService = lib.recursiveUpdate {
      Install.WantedBy = ["graphical-session.target"];
    };
    mkTray = lib.recursiveUpdate {
      Install.WantedBy = ["graphical-session.target"];
    };
  in {
    mako = mkService {
      Unit.Description = "Notification daemon";
      Service.ExecStart = "${pkgs.mako}/bin/mako";
    };

    gammastep = mkService {
      Unit.Description = "Night time color filter";
      Service.ExecStart = "${pkgs.gammastep}/bin/gammastep -m wayland -l 40:-2 -t 6500:3000";
    };

    wallpaper = mkService {
      Unit.Description = "Wallpaper daemon";
      Service.ExecStart = lib.getExe (pkgs.writeShellApplication {
        name = "wallpaper";
        runtimeInputs = with pkgs; [swaybg];
        text = ''
          f=${config.home.homeDirectory}/Pictures/bg
          if [[ -f $f ]]; then
            echo Using $f
            exec swaybg --image $f --mode fill
          else
            echo $f not found
            exec swaybg --color '#000000'
          fi
        '';
      });
    };

    nm-applet = mkTray {
      Unit.Description = "Network applet";
      Service.ExecStart = "${pkgs.networkmanagerapplet}/bin/nm-applet --indicator";
    };

    wob = mkService {
      Service.ExecStart = lib.getExe pkgs.wob;
      Service.StandardInput = "socket";
    };
  };

  systemd.user.sockets = {
    wob = {
      Socket = {
        ListenFIFO = "%t/wob.sock";
        SocketMode = "0600";
        RemoveOnStop = "on";
        FlushPending = "yes";
      };
      Install.WantedBy = ["sockets.target"];
    };
  };

  gtk = {
    enable = true;
    theme = {
      package = packages.self.adw-gtk3;
      name = "adw-gtk3-dark";
    };
    iconTheme = {
      package = packages.self.papirus-icon-theme;
      name = "Papirus-Dark";
    };
    cursorTheme = {
      package = pkgs.vanilla-dmz;
      name = "Vanilla-DMZ";
      size = 24;
    };
    font = {
      package = pkgs.roboto;
      name = "Roboto";
      size = 10.0;
    };
  };

  services.xsettingsd = {
    enable = true;
    settings = {
      # "Gtk/CursorThemeName" = "Vanilla-DMZ";
      "Net/EnableEventSounds" = false;
      "Net/EnableInputFeedbackSounds" = false;
      "Net/IconThemeName" = "Papirus-Dark";
      "Xft/Antialias" = true;
      "Xft/Hinting" = true;
      "Xft/RGBA" = "rgb";
      "Xft/HintStyle" = "hintfull";
      # "Gtk/FontName" = "Roboto, 10";
    };
  };

  services.blueman-applet.enable = true;

  services.swayidle = {
    enable = true;
    timeouts = [
      {
        timeout = 600;
        command = "systemctl suspend";
      }
    ];
  };

  services.kanshi = {
    enable = true;
    systemdTarget = "graphical-session.target";
    profiles.main.outputs = [
      {
        criteria = "DP-3";
        mode = "2560x1440@144Hz";
      }
    ];
  };
}
