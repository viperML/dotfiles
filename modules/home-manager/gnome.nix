{
  config,
  pkgs,
  inputs,
  lib,
  ...
}:
{
  systemd.user = {
    services.apply-colorscheme = {
      Unit.Description = "Apply colorscheme to Gnome";
      Unit.After = ["org.gnome.SettingsDaemon.Datetime.service"];
      Service.Type = "oneshot";
      Service.ExecStartPre = "${pkgs.coreutils-full}/bin/sleep 3";
      Service.ExecStart =
        let
          apply-colorscheme-script = pkgs.writeShellScript "apply-colorscheme-script" ''
            if (( $(date +"%-H%M") < 1800 )) && (( $(date +"%-H%M") > 0500 )); then
              ${pkgs.glib}/bin/set org.gnome.desktop.interface gtk-theme adw-gtk3
            else
              ${pkgs.glib}/bin/set org.gnome.desktop.interface gtk-theme adw-gtk3-dark
            fi
          '';
        in "${apply-colorscheme-script}";
      Install.WantedBy = ["graphical-session.target"];
    };
    timers = {
      apply-colorscheme = {
        Unit.Description = "Apply colorscheme on schedule";
        Unit.PartOf = ["apply-colorscheme.service"];
        # DayOfWeek Year-Month-Day Hour:Minute:Second
        Timer.OnCalendar = ["*-*-* 18:01:00" "*-*-* 05:01:00"];
        # Timer.Persistent = "true";
        # Timer.OnBootSec = "2s";
        Install.WantedBy = ["timers.target"];
      };
    };
  };
}
