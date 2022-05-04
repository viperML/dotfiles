{
  config,
  pkgs,
  inputs,
  lib,
  packages,
  ...
}: {
  home.packages = [
    packages.self.plasma-applet-splitdigitalclock
  ];

  systemd.user = {
    services = {
      apply-colorscheme = with pkgs; {
        Unit.Description = "Apply colorscheme to KDE";
        Unit.After = ["plasma-plasmashell.service"];
        Service.ExecStartPre = "${coreutils}/bin/sleep 3";
        Service.ExecStart =
          (writeShellScript "apply-colorscheme-script" ''
            if (( $(date +"%-H%M") < 1800 )) && (( $(date +"%-H%M") > 0500 )); then
              ${plasma-workspace}/bin/plasma-apply-colorscheme BreezeLight
              ${dbus}/bin/dbus-send --session --dest=org.kde.GtkConfig --type=method_call /GtkConfig org.kde.GtkConfig.setGtkTheme 'string:adw-gtk3'
            else
              ${plasma-workspace}/bin/plasma-apply-colorscheme ReversalDark
              ${dbus}/bin/dbus-send --session --dest=org.kde.GtkConfig --type=method_call /GtkConfig org.kde.GtkConfig.setGtkTheme 'string:adw-gtk3-dark'
            fi
          '')
          .outPath;
        Install.WantedBy = ["xdg-desktop-autostart.target"];
      };
    };
    timers.apply-colorscheme = {
      Unit.Description = "Apply colorscheme on schedule";
      Unit.PartOf = ["apply-colorscheme.service"];
      # DayOfWeek Year-Month-Day Hour:Minute:Second
      Timer.OnCalendar = ["*-*-* 18:01:00" "*-*-* 05:01:00"];
      Install.WantedBy = ["timers.target"];
    };
    targets.tray = {
      Unit = {
        Description = "Current graphical tray";
        BindsTo = ["graphical-session.target"];
        Wants = ["graphical-session.target"];
        After = ["graphical-session.target"];
      };
    };
  };
}
