args @ {
  config,
  pkgs,
  lib,
  ...
}: {
  wayland.windowManager.sway = {
    enable = true;
    # Use NixOS module system to install
    package = null;
    systemdIntegration = true;
    config = import ./config.nix {inherit args;};
  };

  home.packages = with pkgs; [
    wofi
    plasma5Packages.dolphin
    libsForQt5.ffmpegthumbs
    libsForQt5.kdegraphics-thumbnailers
  ];

  systemd.user.services = {
    i3a = {
      Unit.Description = "Master+stack tiling daemon";
      Service.ExecStart = "${pkgs.i3a}/bin/i3a-master-stack --stack dwm";
      Install.WantedBy = ["sway-session.target"];
    };

    mako = {
      Unit.Description = "Notification daemon";
      Service.ExecStart = "${pkgs.mako}/bin/mako";
      Install.WantedBy = ["sway-session.target"];
    };

    waybar = {
      Unit.Description = "System bar";
      Service.ExecStart = "${pkgs.waybar}/bin/waybar";
      Install.WantedBy = ["sway-session.target"];
    };
  };
}
