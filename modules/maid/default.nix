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
  ];

  config = {
    file.xdg_config."hypr/hyprland.conf".source =
      "${config.impureDotfilesPath}/modules/maid/hyprland/hyprland.conf";

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
