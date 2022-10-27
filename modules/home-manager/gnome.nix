{
  config,
  lib,
  packages,
  pkgs,
  ...
}: let
  inherit (config.lib) gvariant;
in {
  dconf.settings = {
    "org/gnome/desktop/wm/keybindings" =
      (builtins.listToAttrs (map (number: lib.nameValuePair "switch-to-workspace-${number}" (gvariant.mkArray gvariant.type.string ["<Super>${number}"])) (map builtins.toString (lib.range 1 9))))
      // (builtins.listToAttrs (map (number: lib.nameValuePair "move-to-workspace-${number}" (gvariant.mkArray gvariant.type.string ["<Super><Shift>${number}"])) (map builtins.toString (lib.range 1 9))))
      // {
        "close" = gvariant.mkArray gvariant.type.string ["<Super>Q"];
      };
    "org/gnome/shell/keybindings" = builtins.listToAttrs (map (number: lib.nameValuePair "switch-to-application-${number}" (gvariant.mkArray gvariant.type.string [])) (map builtins.toString (lib.range 1 9)));
    "org/gnome/desktop/wm/preferences" = {
      "resize-with-right-button" = gvariant.mkBoolean true;
      "focus-mode" = gvariant.mkValue "sloppy";
    };
    "org/gnome/mutter" = {
      "focus-change-on-pointer-rest" = gvariant.mkBoolean false;
    };
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
      binding = gvariant.mkString "<Super>e";
      command = gvariant.mkString "nautilus";
      name = gvariant.mkString "explorer";
    };
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1" = {
      binding = gvariant.mkString "<Super>Return";
      command = gvariant.mkString (
        if config.viper.isWayland
        then "foot"
        else "wezterm"
      );
      name = gvariant.mkString "terminal";
    };
    "org/gnome/shell/extensions/pop-shell" = {
      "tile-by-default" = gvariant.mkBoolean true;
      "tile-enter" = gvariant.mkArray gvariant.type.string [];
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

  home.packages = lib.mkIf config.viper.isWayland [
    packages.self.foot
  ];
}
