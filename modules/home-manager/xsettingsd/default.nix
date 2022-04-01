{
  config,
  pkgs,
  ...
} @ args: {
  systemd.user = {
    services = {
      xsettingsd = {
        Unit.Description = "Cross desktop configuration daemon";
        Service.ExecStart = "${pkgs.xsettingsd}/bin/xsettingsd";
        Unit.After = [
          "xsettingsd-switch.service"
          "graphical-session.target"
        ];
        Unit.PartOf = ["graphical-session.target"];
        Install.WantedBy = ["graphical-session.target"];
      };
      xsettingsd-switch = let
        xsettingsConfig = import ./settings.nix {inherit args;};
        xsettingsd-switch-script = pkgs.writeShellScript "xsettings-switch" ''
          export PATH="${pkgs.coreutils-full}/bin:${pkgs.systemd}/bin"
          mkdir -p ${config.xdg.configHome}/xsettingsd
          if (( $(date +"%-H%M") < 1800 )) && (( $(date +"%-H%M") > 0500 )); then
            ln -sf ${xsettingsConfig.light} ${config.xdg.configHome}/xsettingsd/xsettingsd.conf
          else
            ln -sf ${xsettingsConfig.dark} ${config.xdg.configHome}/xsettingsd/xsettingsd.conf
          fi
          systemctl --user restart xsettingsd.service
        '';
      in {
        Unit.Description = "Reload the xsettingsd with new configuration";
        Service.ExecStart = xsettingsd-switch-script.outPath;
        Unit.PartOf = ["graphical-session.target"];
        Unit.After = ["graphical-session.target"];
        Install.WantedBy = ["graphical-session.target"];
      };
    };
    timers = {
      xsettingsd-switch = {
        Unit.Description = "Apply xsettings on schedule";
        Unit.PartOf = ["xsettingsd-switch.service"];
        Timer.OnCalendar = ["*-*-* 18:01:00" "*-*-* 05:01:00"];
        Install.WantedBy = ["timers.target"];
      };
    };
  };
}
