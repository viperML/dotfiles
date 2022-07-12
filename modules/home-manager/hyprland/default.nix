{pkgs, ...}: {
  xdg.configFile."hypr/hyprland.conf".source =
    (pkgs.substituteAll {
      src = ./hyprland.conf;
    })
    .outPath;

  home.packages = [
    pkgs.foot
    pkgs.wofi
    pkgs.firefox
  ];

  systemd.user.targets.hyprland-session = {
    Unit = {
      Description = "hyprland compositor session";
      BindsTo = ["graphical-session.target"];
      Wants = ["graphical-session-pre.target"];
      After = ["graphical-session-pre.target"];
    };
  };

  systemd.user.services = {
    waybar = {
      Unit.Description = "System bar";
      Service.ExecStart = "${pkgs.waybar}/bin/waybar";
      Install.WantedBy = ["graphical-session.target"];
    };
  };
}
