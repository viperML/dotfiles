{
  config,
  lib,
  pkgs,
  ...
}:
{
  options = {
    impureDotfilesPath = lib.mkOption {
      type = lib.types.str;
      default = "{{home}}/Documents/dotfiles";
    };
  };

  config = {
    file.home.".gitconfig".source = pkgs.git-viper.gitconfig;

    dconf.settings = {
      "/org/gnome/desktop/interface/color-scheme" = "prefer-dark";
      "/org/gnome/desktop/interface/cursor-size" = 24;
      "/org/gnome/desktop/interface/cursor-theme" = "DMZ-White";
      "/org/gnome/desktop/interface/document-font-name" = "Roboto 11";
      "/org/gnome/desktop/interface/enable-hot-corners" = "false";
      "/org/gnome/desktop/interface/font-name" = "Roboto 11";
      "/org/gnome/desktop/interface/gtk-enable-primary-paste" = "false";
      "/org/gnome/desktop/interface/gtk-theme" = "adw-gtk3-dark";
      "/org/gnome/desktop/interface/icon-theme" = "Adwaita";
      "/org/gnome/desktop/lockdown/disable-lock-screen" = "true";
      "/org/gnome/desktop/peripherals/mouse/accel-profile" = "flat";
      "/org/gnome/desktop/wm/preferences/titlebar-font" = "Roboto Bold 11";
      "/org/gnome/desktop/peripherals/touchpad/click-method" = "areas";
      "/org/gnome/desktop/interface/show-battery-percentage" = "true";
      "/org/gnome/desktop/interface/clock-format" = "12h";
      "/org/gnome/desktop/wm/preferences/resize-with-right-button" = true;
      "/org/gnome/desktop/search-providers/disabled" = [
        "org.gnome.Characters.desktop"
        "org.gnome.clocks.desktop"
        "org.gnome.seahorse.Application.desktop"
        "org.gnome.Nautilus.desktop"
      ];
      "/org/gnome/shell/disable-user-extensions" = false;
      "/org/gnome/shell/enabled-extensions" = [
        "appindicatorsupport@rgcjonas.gmail.com"
        "dash-to-panel@jderose9.github.com"
      ];
    };
  };
}
