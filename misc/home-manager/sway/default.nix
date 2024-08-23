{
  pkgs,
  packages,
  lib,
  ...
}: {
  imports = [./config.nix ../wayland-compositors ../waybar ./fx.nix];

  options = {wayland.windowManager.sway.fx = lib.mkEnableOption "swayfx";};

  config = {
    wayland.windowManager.sway = {
      enable = true;
      # Use NixOS module system to install
      package = null;
      systemd.enable = true;
    };

    home.packages = [packages.self.wezterm];

    systemd.user.services = {
      autotiling = {
        Install.WantedBy = ["graphical-session.target"];
        Unit.Description = "Autotiling";
        Service.ExecStart = "${pkgs.autotiling-rs}/bin/autotiling-rs";
      };
    };
  };
}
