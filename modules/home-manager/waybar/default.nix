{
  pkgs,
  config,
  ...
}: let
  configPath = "${config.unsafeFlakePath}/modules/home-manager/waybar/config.json";
  stylePath = "${config.unsafeFlakePath}/modules/home-manager/waybar/style.css";

  waybarPackage = config.programs.waybar.package;
in {
  home.packages = [waybarPackage];

  systemd.user.services.waybar = {
    Unit.Description = "System bar";
    Service.ExecStart = "${waybarPackage}/bin/waybar --config ${configPath} --style ${stylePath}";
    Install.WantedBy = ["graphical-session.target"];
  };
}
