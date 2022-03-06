{
  pkgs,
  lib,
  config,
  self,
  ...
}: let
  selfPath =
    if lib.hasAttr "FLAKE" config.home.sessionVariables
    then "${config.home.sessionVariables.FLAKE}/modules/home-manager/nwg-panel"
    else "${self.outPath}/modules/home-manager/nwg-panel";
in {
  home.packages = with pkgs; [
    #keep
  ];

  systemd.user.services = {
    nwg-panel = {
      Unit.Description = "Highly customizable Wayland bar for Wlroots based compositors";
      Unit.PartOf = ["graphical-session.target"];
      Unit.After = ["graphical-session.target"];
      Service.ExecStart = "${pkgs.nwg-panel}/bin/nwg-panel";
      Service.Restart = "on-failure";
      Service.KillMode = "mixed";
      Install.WantedBy = ["sway-session.target"];
    };
  };

  systemd.user.tmpfiles.rules = [
    "L+ ${config.home.homeDirectory}/.config/nwg-panel - - - - ${selfPath}"
  ];
}
