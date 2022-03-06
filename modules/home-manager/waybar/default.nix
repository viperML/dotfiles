{
  pkgs,
  lib,
  config,
  self,
  ...
}: let
  selfPath =
    if lib.hasAttr "FLAKE" config.home.sessionVariables
    then "${config.home.sessionVariables.FLAKE}/modules/home-manager/waybar"
    else "${self.outPath}/modules/home-manager/waybar";
in {
  home.packages = with pkgs; [
    font-awesome
  ];

  systemd.user.services = {
    waybar = {
      Unit.Description = "Highly customizable Wayland bar for Wlroots based compositors";
      Unit.PartOf = ["graphical-session.target"];
      Unit.After = ["graphical-session.target"];
      Service.ExecStart = "${pkgs.waybar}/bin/waybar";
      Service.ExecReload = "kill -SIGUSR2 $MAINPID";
      Service.Restart = "on-failure";
      Service.KillMode = "mixed";
      Install.WantedBy = ["sway-session.target"];
    };
  };

  systemd.user.tmpfiles.rules = [
    "L+ ${config.home.homeDirectory}/.config/waybar - - - - ${selfPath}"
  ];
}
