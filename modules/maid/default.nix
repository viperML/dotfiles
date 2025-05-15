{
  config,
  lib,
  ...
}:
{
  options = {
    impureDotfilesPath = lib.mkOption {
      type = lib.types.str;
      default = "{{home}}/Documents/dotfiles";
    };
  };

  imports = [
    ./waybar
    ./dunst
    ./clipman
    ./wallpaper
  ];

  config = {
    file.xdg_config."hypr/hyprland.conf".source =
      "${config.impureDotfilesPath}/modules/maid/hyprland/hyprland.conf";

    systemd.tmpfiles.dynamicRules = [ 
      "f {{xdg_config_home}}/hypr/monitors.conf 0644 {{user}} {{group}} - -"
    ];

    systemd.targets.hyprland-session = {
      unitConfig = {
        Description = "hyprland compositor session";
        BindsTo = [ "graphical-session.target" ];
        Wants = [
          "graphical-session-pre.target"
          "xdg-desktop-autostart.target"
        ];
        After = [ "graphical-session-pre.target" ];
        Before = [ "xdg-desktop-autostart.target" ];
      };
    };
  };
}
