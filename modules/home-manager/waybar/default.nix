{
  pkgs,
  config,
  packages,
  flakePath,
  ...
}: let
  configPath = "${flakePath}/modules/home-manager/waybar/config";
  stylePath = "${flakePath}/modules/home-manager/waybar/style.css";

  waybarPackage = packages.hyprland.waybar-hyprland;
in {
  home.packages = [waybarPackage];

  systemd.user.services.waybar = {
    Unit.Description = "System bar";
    Service.ExecStart = "${waybarPackage}/bin/waybar --config ${configPath} --style ${stylePath}";
    Install.WantedBy = ["graphical-session.target"];
  };
}
