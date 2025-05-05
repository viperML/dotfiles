{
  config,
  lib,
  pkgs,
  ...
}:
{
  # programs.waybar = {
  #   enable = true;
  #   systemd.enable = true;
  # };
  #
  # xdg.configFile = let
  #   onChange = ''
  #     ${pkgs.procps}/bin/pkill -u $USER -USR2 waybar || true
  #   '';
  # in {
  #   "waybar/config" = {
  #     inherit onChange;
  #     source =
  #       config.lib.file.mkOutOfStoreSymlink
  #       "${config.unsafeFlakePath}/modules/home-manager/waybar/config.json";
  #   };
  #   "waybar/style.css" = {
  #     inherit onChange;
  #     source =
  #       config.lib.file.mkOutOfStoreSymlink
  #       "${config.unsafeFlakePath}/modules/home-manager/waybar/style.css";
  #   };
  # };

  packages = [
    pkgs.waybar
  ];

  systemd.services = {
    "waybar" = {
      path = [ pkgs.waybar ];
      script = ''
        waybar
      '';
      wantedBy = [ "graphical-session.target" ];
    };
  };

  file.xdg_config."waybar".source = "${config.impureDotfilesPath}/modules/maid/waybar";
}
