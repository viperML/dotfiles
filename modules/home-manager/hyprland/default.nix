{
  pkgs,
  config,
  lib,
  packages,
  ...
}: {
  xdg.configFile."hypr/hyprland.conf".source = config.lib.file.mkOutOfStoreSymlink "${config.home.sessionVariables.FLAKE}/modules/home-manager/hyprland/hyprland.conf";

  home.packages = [
    pkgs.foot
    pkgs.wofi
    packages.hyprland-contrib.grimblast
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
    # waybar = {
    #   Unit.Description = "System bar";
    #   Service.ExecStart = "${pkgs.waybar}/bin/waybar";
    #   Install.WantedBy = ["graphical-session.target"];
    # };
    swaybg = {
      Unit.Description = "Wallpaper";
      Service.ExecStart = "${lib.getExe pkgs.swaybg} -c '#121212'";
      Install.WantedBy = ["graphical-session.target"];
    };
  };
}
