{
  config,
  lib,
  pkgs,
  ...
}: {
  programs.waybar = {
    enable = true;
    systemd.enable = true;
  };

  xdg.configFile = let
    onChange = ''
      ${pkgs.procps}/bin/pkill -u $USER -USR2 waybar || true
    '';
  in {
    "waybar/config" = {
      inherit onChange;
      source =
        config.lib.file.mkOutOfStoreSymlink
        "${config.unsafeFlakePath}/modules/home-manager/waybar/config.json";
    };
    "waybar/style.css" = {
      inherit onChange;
      source =
        config.lib.file.mkOutOfStoreSymlink
        "${config.unsafeFlakePath}/modules/home-manager/waybar/style.css";
    };
  };
}
