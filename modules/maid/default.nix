{ config, pkgs, ... }:
{
  file.xdg_config."hypr/hyprland.conf".source =
    "{{home}}/Documents/dotfiles/modules/maid/hyprland.conf";

  systemd.services = {
    "waybar" = {
      path = [ pkgs.waybar ];
      script = ''
        waybar
      '';
      wantedBy = [ "graphical-session.target" ];
    };
  };

  systemd.targets.hyprland-session = {
    unitConfig = {
      Description = "hyprland compositor session";
      BindsTo = ["graphical-session.target"];
      Wants = ["graphical-session-pre.target" "xdg-desktop-autostart.target"];
      After = ["graphical-session-pre.target"];
      Before = ["xdg-desktop-autostart.target"];
    };
  };
}
