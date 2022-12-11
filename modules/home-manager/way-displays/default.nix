{pkgs, ...}: {
  home.packages = [pkgs.way-displays];

  xdg.configFile."way-displays/cfg.yaml".source = ./cfg.yaml;

  systemd.user.services.way-displays = {
    Unit.Description = "Display configuration";
    Service.ExecStart = "${pkgs.way-displays}/bin/way-displays";
    Install.WantedBy = ["graphical-session.target"];
  };
}
