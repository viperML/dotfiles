{ config, pkgs, inputs, lib, ... }:

{
  home.packages =
    [
      pkgs.plasma-applet-splitdigitalclock
    ];

  systemd.user = {
    services.apply-colorscheme = {
      Unit.Description = "Apply colorscheme to KDE";
      Unit.After = [ "plasma-plasmashell.service" ];
      Service.Type = "oneshot";
      Service.ExecStart =
        let
          apply-colorscheme-script = pkgs.writeShellScript "apply-colorscheme-script" ''
            sleep 10
            if (( $(date +"%-H%M") <  1800 )) && (( $(date +"%-H%M") > 0500 )); then
              ${pkgs.plasma-workspace}/bin/plasma-apply-colorscheme KritaBright
              ln -sf ${config.xdg.configHome}/kitty/dracula-dark.conf ${config.xdg.configHome}/kitty/theme.conf
            else
              ${pkgs.plasma-workspace}/bin/plasma-apply-colorscheme ReversalDark
              ln -sf ${config.xdg.configHome}/kitty/dracula-dark.conf ${config.xdg.configHome}/kitty/theme.conf
            fi
          '';
        in
        "${apply-colorscheme-script}";
    };
    timers = {
      apply-colorscheme = {
        Unit.Description = "Apply colorscheme on schedule";
        Unit.PartOf = [ "apply-colorscheme.service" ];
        # DayOfWeek Year-Month-Day Hour:Minute:Second
        Timer.OnCalendar = [ "*-*-* 18:01:00" "*-*-* 05:01:00" ];
        Timer.Persistent = "true";
        Install.WantedBy = [ "timers.target" ];
      };
    };
  };
}
