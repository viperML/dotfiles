{
  config,
  pkgs,
  ...
}:
let
  kitty-themes = pkgs.fetchFromGitHub {
    owner = "kovidgoyal";
    repo = "kitty-themes";
    rev = "6b06ed8661c62b1fcc63c9de9054d9cc12c319f6";
    sha256 = "0543d6ghx3s6fjxkzb78j5wj77ag20z46kzi2b6lyqkm7swwvm2c";
  };
in {
  home.packages = [pkgs.kitty];

  xdg.configFile = {
    "kitty/kitty.conf".text = ''
      shell fish
      term xterm-256color
      include theme.conf

      ${builtins.readFile ./kitty.conf}
    '';
    "kitty/theme-dark.conf".source = ./dracula-dark.conf;
    "kitty/theme-light.conf".source = "${kitty-themes}/themes/AtomOneLight.conf";
  };

  home.activation.kitty = {
    after = ["writeBoundary"];
    before = [];
    data = config.systemd.user.services.apply-kitty.Service.ExecStart;
  };

  systemd.user = {
    services.apply-kitty = {
      Unit.Description = "Apply colorscheme to kitty";
      Unit.After = ["plasma-plasmashell.service"];
      Service.Type = "oneshot";
      Service.ExecStart =
        let
          apply-kitty-script = pkgs.writeShellScript "apply-kitty-script" ''
            set -eux
            if (( $(date +"%-H%M") < 1800 )) && (( $(date +"%-H%M") > 0500 )); then
              ln -sf ${config.xdg.configHome}/kitty/theme-light.conf ${config.xdg.configHome}/kitty/theme.conf
            else
              ln -sf ${config.xdg.configHome}/kitty/theme-dark.conf ${config.xdg.configHome}/kitty/theme.conf
            fi
          '';
        in "${apply-kitty-script}";
    };
    timers = {
      apply-kitty = {
        Unit.Description = "Apply colorscheme on schedule";
        Unit.PartOf = ["apply-kitty.service"];
        # DayOfWeek Year-Month-Day Hour:Minute:Second
        Timer.OnCalendar = ["*-*-* 18:01:00" "*-*-* 05:01:00"];
        # Timer.Persistent = "true";
        # Timer.OnBootSec = "1mim";
        Install.WantedBy = ["timers.target"];
      };
    };
  };
}
