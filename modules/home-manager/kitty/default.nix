{ config
, pkgs
, ...
}:
{
  home.packages = [ pkgs.kitty ];

  xdg.configFile = {
    "kitty/kitty.conf".text = ''
      shell fish
      term xterm-256color
      include theme.conf

      ${builtins.readFile ./kitty.conf}
    '';
    "kitty/dracula-dark.conf".source = ./dracula-dark.conf;
    "kitty/dracula-light-darker.conf".source = ./dracula-light-darker.conf;
  };

  home.activation.kitty = {
    after = [ "writeBoundary" ];
    before = [ ];
    data = config.systemd.user.services.apply-kitty.Service.ExecStart;
  };

  systemd.user = {
    services.apply-kitty = {
      Unit.Description = "Apply colorscheme to kitty";
      Unit.After = [ "plasma-plasmashell.service" ];
      Service.Type = "oneshot";
      Service.ExecStart =
        let
          apply-kitty-script = pkgs.writeShellScript "apply-kitty-script" ''
            set -eux
            if (( $(date +"%-H%M") < 1800 )) && (( $(date +"%-H%M") > 0500 )); then
              ln -sf ${config.xdg.configHome}/kitty/dracula-light-darker.conf ${config.xdg.configHome}/kitty/theme.conf
            else
              ln -sf ${config.xdg.configHome}/kitty/dracula-dark.conf ${config.xdg.configHome}/kitty/theme.conf
            fi
          '';
        in
          "${apply-kitty-script}";
    };
    timers = {
      apply-kitty = {
        Unit.Description = "Apply colorscheme on schedule";
        Unit.PartOf = [ "apply-kitty.service" ];
        # DayOfWeek Year-Month-Day Hour:Minute:Second
        Timer.OnCalendar = [ "*-*-* 18:01:00" "*-*-* 05:01:00" ];
        # Timer.Persistent = "true";
        # Timer.OnBootSec = "1mim";
        Install.WantedBy = [ "timers.target" ];
      };
    };
  };
}
