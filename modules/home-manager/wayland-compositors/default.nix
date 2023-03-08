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
    # mako = mkService {
    #   Unit.Description = "Notification daemon";
    #   Service.ExecStart = "${pkgs.mako}/bin/mako";
    # };

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
    systemdTarget = "graphical-session.target";
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

  services.dunst = {
    enable = true;
    settings = let
      foreground = "#FFFFFF";
      background = "#121212";
      frame_color = "#21dec8";
    in {
      global = {
        font = "Roboto 11";
        origin = "top-center";
        corner_radius = 5;
        alignment = "center";
        follow = "mouse";
        format = "<b>%s</b>\\n%b";
        frame_width = 4;
        offset = "5x5";
        horizontal_padding = 8;
        icon_position = "left";
        indicate_hidden = "yes";
        markup = "yes";
        max_icon_size = 64;
        mouse_left_click = "do_action";
        mouse_middle_click = "close_all";
        mouse_right_click = "close_current";
        padding = 8;
        plain_text = "no";
        separator_color = "auto";
        separator_height = 1;
        show_indicators = false;
        shrink = "no";
        word_wrap = "yes";
      };
      fullscreen_delay_everything = {fullscreen = "delay";};
      urgency_critical = {
        inherit foreground background;
        frame_color = "#551212";
      };
      urgency_low = {
        inherit background foreground frame_color;
      };
      urgency_normal = {
        inherit background foreground frame_color;
      };
    };
  };
}
