{
  config,
  lib,
  packages,
  pkgs,
  ...
}: let
  inherit (config.lib) gvariant;
  term = packages.self.wezterm;
  term_exe = "wezterm";
in {
  dconf.enable = true;
  dconf.settings = let
    shortcuts = {
      "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
        binding = gvariant.mkString "<Super>e";
        command = gvariant.mkString "nautilus";
        name = gvariant.mkString "explorer";
      };
      "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1" = {
        binding = gvariant.mkString "<Super>Return";
        command = gvariant.mkString term_exe;
        name = gvariant.mkString "terminal";
      };
    };
  in {
    "org/gnome/desktop/wm/keybindings" =
      (builtins.listToAttrs (map (number:
        lib.nameValuePair "switch-to-workspace-${number}"
        (gvariant.mkArray gvariant.type.string ["<Super>${number}"]))
      (map builtins.toString (lib.range 1 9))))
      // (builtins.listToAttrs (map
        (number:
          lib.nameValuePair "move-to-workspace-${number}"
          (gvariant.mkArray gvariant.type.string ["<Super><Shift>${number}"]))
        (map builtins.toString (lib.range 1 9))))
      // {
        "close" = gvariant.mkArray gvariant.type.string ["<Super>Q"];
      };
    "org/gnome/shell/keybindings" = builtins.listToAttrs (map (number:
      lib.nameValuePair "switch-to-application-${number}"
      (gvariant.mkArray gvariant.type.string []))
    (map builtins.toString (lib.range 1 9)));
    "org/gnome/desktop/wm/preferences" = {
      "resize-with-right-button" = gvariant.mkBoolean true;
      "focus-mode" = gvariant.mkValue "sloppy";
    };
    "org/gnome/mutter" = {
      "experimental-features" =
        gvariant.mkArray gvariant.type.string ["scale-monitor-framebuffer"];
      "focus-change-on-pointer-rest" = gvariant.mkBoolean false;
      "overlay-key" = gvariant.mkString "Super_L";
    };
    "org/gnome/settings-daemon/plugins/media-keys" = {
      "custom-keybindings" =
        gvariant.mkArray gvariant.type.string
        (map (key: "/${key}/") (builtins.attrNames shortcuts));
    };
    "org/gnome/shell/extensions/pop-shell" = {
      "tile-by-default" = gvariant.mkBoolean true;
      "tile-enter" = gvariant.mkArray gvariant.type.string [];
      "tile-accept" = gvariant.mkArray gvariant.type.string [];
    };
    "org/gnome/desktop/interface" = {};
    "org/gnome/shell" = {
      "enabled-extensions" = gvariant.mkArray gvariant.type.string [
        "appindicatorsupport@rgcjonas.gmail.com"
        # "blur-my-shell@aunetx"
        "tailscale-status@maxgallup.github.com"
      ];
    };
    "org/gnome/desktop/interface" = {
      "enable-hot-corners" = gvariant.mkBoolean false;
      "gtk-theme" = gvariant.mkString "adw-gtk3-dark";
      "font-hinting" = gvariant.mkString "full";
      "font-antialiasing" = gvariant.mkString "rgba";
      "font-name" = gvariant.mkString "Roboto 11";
      "document-font-name" = gvariant.mkString "Roboto 11";
      "gtk-enable-primary-paste" = gvariant.mkBoolean false;
      "color-scheme" = gvariant.mkString "prefer-dark";
      "icon-theme" = gvariant.mkString "Adwaita";
      "cursor-theme" = gvariant.mkString config.home.pointerCursor.name;
      "cursor-size" = gvariant.mkInt32 config.home.pointerCursor.size;
    };
    "org/gnome/desktop/wm/preferences" = {
      "titlebar-font" = gvariant.mkString "Roboto Bold 11";
    };
    "org/gnome/desktop/peripherals/mouse" = {
      "accel-profile" = gvariant.mkString "flat";
    };
    # "org/gnome/shell/extensions/blur-my-shell" = {
    #   "panel/blur" = gvariant.mkBoolean false;
    #   "applications/blur" = gvariant.mkBoolean false;
    # };
    "org/gnome/desktop/session" = {"idle-delay" = gvariant.mkUint32 600;};
    "org/gnome/settings-daemon/plugins/power" = {
      "sleep-inactive-ac-timeout" = gvariant.mkInt32 900;
    };
    "org/gnome/settings-daemon/plugins/color" = {
      "night-light-enabled" = gvariant.mkBoolean true;
      "night-light-schedule-automatic" = gvariant.mkBoolean true;
      "night-light-temperature" = gvariant.mkUint32 2355;
    };
    "org/gnome/desktop/lockdown" = {
      "disable-lock-screen" = gvariant.mkBoolean true;
    };
    "org/gnome/shell" = {
      "disable-user-extensions" = gvariant.mkBoolean false;
    };
    "org/gnome/desktop/peripherals/touchpad" = {
      "click-method" = gvariant.mkString "areas";
    };
  };

  systemd.user = {
    targets."tray" = {
      Unit = {
        Description = "Home-manager tray target";
        # Requires = ["gnome-session.target"];
        # After = ["gnome-session.target"];
        BindsTo = ["gnome-session.target"];
      };
      Install.WantedBy = ["gnome-session.target"];
    };
  };

  home.packages = [term];

  # Weird
  xdg.userDirs.enable = lib.mkForce false;

  home.pointerCursor = {
    package = pkgs.vanilla-dmz;
    name = "DMZ-White";
    size = 24;
    gtk.enable = true;
  };
}
