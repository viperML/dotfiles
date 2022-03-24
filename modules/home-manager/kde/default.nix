{
  config,
  pkgs,
  inputs,
  lib,
  ...
}: {
  home.packages = [
    pkgs.plasma-applet-splitdigitalclock
    pkgs.caffeine-ng
  ];

  systemd.user = {
    services = {
      apply-colorscheme = {
        Unit.Description = "Apply colorscheme to KDE";
        Unit.After = ["plasma-plasmashell.service"];
        Service.Type = "oneshot";
        Service.ExecStartPre = "${pkgs.coreutils-full}/bin/sleep 3";
        Service.ExecStart = let
          apply-colorscheme-script = pkgs.writeShellScript "apply-colorscheme-script" ''
            if (( $(date +"%-H%M") < 1800 )) && (( $(date +"%-H%M") > 0500 )); then
              ${pkgs.plasma-workspace}/bin/plasma-apply-colorscheme BreezeLight
              ${pkgs.dbus}/bin/dbus-send --session --dest=org.kde.GtkConfig --type=method_call /GtkConfig org.kde.GtkConfig.setGtkTheme 'string:adw-gtk3'
            else
              ${pkgs.plasma-workspace}/bin/plasma-apply-colorscheme ReversalDark
              ${pkgs.dbus}/bin/dbus-send --session --dest=org.kde.GtkConfig --type=method_call /GtkConfig org.kde.GtkConfig.setGtkTheme 'string:adw-gtk3-dark'
            fi
          '';
        in "${apply-colorscheme-script}";
        Install.WantedBy = ["xdg-desktop-autostart.target"];
      };
      caffeine = {
        Unit.Description = "Caffeine";
        Service.ExecStart = "${pkgs.caffeine-ng}/bin/caffeine";
        Unit.After = ["plasma-plasmashell"];
        Install.WantedBy = ["graphical-session.target"];
      };
      mailspring = {
        Unit.Description = "Mailspring";
        Service.ExecStart = "${pkgs.mailspring}/bin/mailspring --background";
        Unit.After = ["plasma-plasmashell"];
        Install.WantedBy = ["graphical-session.target"];
      };
    };
    timers.apply-colorscheme = {
      Unit.Description = "Apply colorscheme on schedule";
      Unit.PartOf = ["apply-colorscheme.service"];
      # DayOfWeek Year-Month-Day Hour:Minute:Second
      Timer.OnCalendar = ["*-*-* 18:01:00" "*-*-* 05:01:00"];
      Install.WantedBy = ["timers.target"];
    };
  };
}
