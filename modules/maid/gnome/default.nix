{pkgs, ... }: {
  gsettings.settings = {
    org.gnome.mutter.experimental-features = [
      "scale-monitor-framebuffer"
      "xwayland-native-scaling"
    ];
  };

  file.home.".icons/default".source = "${pkgs.vanilla-dmz}/share/icons/DMZ-White";

  dconf.settings = {
    "/org/gnome/desktop/interface/color-scheme" = "prefer-dark";
    "/org/gnome/desktop/interface/cursor-size" = 24;
    "/org/gnome/desktop/interface/cursor-theme" = "DMZ-White";
    "/org/gnome/desktop/interface/document-font-name" = "Inter 11";
    "/org/gnome/desktop/interface/monospace-font-name" = "iosevka-normal Medium 11";
    "/org/gnome/desktop/interface/enable-hot-corners" = false;
    "/org/gnome/desktop/interface/font-name" = "Inter 11";
    "/org/gnome/desktop/interface/gtk-enable-primary-paste" = false;
    "/org/gnome/desktop/interface/gtk-theme" = "adw-gtk3-dark";
    "/org/gnome/desktop/interface/icon-theme" = "Adwaita";
    "/org/gnome/desktop/lockdown/disable-lock-screen" = true;
    "/org/gnome/desktop/peripherals/mouse/accel-profile" = "flat";
    "/org/gnome/desktop/wm/preferences/titlebar-font" = "Inter Bold 11";
    "/org/gnome/desktop/peripherals/touchpad/click-method" = "areas";
    "/org/gnome/desktop/interface/show-battery-percentage" = true;
    "/org/gnome/desktop/interface/clock-format" = "12h";
    "/org/gnome/desktop/wm/preferences/resize-with-right-button" = true;
    "/org/gnome/desktop/search-providers/disabled" = [
      "org.gnome.Characters.desktop"
      "org.gnome.clocks.desktop"
      "org.gnome.seahorse.Application.desktop"
      "org.gnome.Nautilus.desktop"
      # "user-theme@gnome-shell-extensions.gcampax.github.com"
    ];
    "/org/gnome/shell/disable-user-extensions" = false;
    "/org/gnome/shell/enabled-extensions" = [
      "appindicatorsupport@rgcjonas.gmail.com"
      "dash-to-panel@jderose9.github.com"
      "monitor@astraext.github.io"
      "clipboard-history@alexsaveau.dev"
      "rounded-window-corners@fxgn"
    ];
    "/org/gnome/shell/keybindings/switch-to-application-1" = [ ];
    "/org/gnome/shell/keybindings/switch-to-application-2" = [ ];
    "/org/gnome/shell/keybindings/switch-to-application-3" = [ ];
    "/org/gnome/shell/keybindings/switch-to-application-4" = [ ];
    "/org/gnome/desktop/wm/keybindings/switch-to-workspace-1" = [ "<Super>1" ];
    "/org/gnome/desktop/wm/keybindings/switch-to-workspace-2" = [ "<Super>2" ];
    "/org/gnome/desktop/wm/keybindings/switch-to-workspace-3" = [ "<Super>3" ];
    "/org/gnome/desktop/wm/keybindings/switch-to-workspace-4" = [ "<Super>4" ];
    "/org/gnome/desktop/wm/keybindings/move-to-workspace-1" = [ "<Shift><Super>1" ];
    "/org/gnome/desktop/wm/keybindings/move-to-workspace-2" = [ "<Shift><Super>2" ];
    "/org/gnome/desktop/wm/keybindings/move-to-workspace-3" = [ "<Shift><Super>3" ];
    "/org/gnome/desktop/wm/keybindings/move-to-workspace-4" = [ "<Shift><Super>4" ];
    "/org/gnome/desktop/wm/keybindings/close" = [ "<Super>q" ];
    "/org/gnome/mutter/dynamic-workspaces" = false;
    "/org/gnome/desktop/wm/preferences/num-workspaces" = 4;
    "/org/gnome/mutter/workspaces-only-on-primary" = false;
  };
}
