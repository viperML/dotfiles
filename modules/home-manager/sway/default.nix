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
    inherit (import ./config.nix {inherit args;}) config extraConfig;
  };

  home.packages = with pkgs; [
    wofi
    nwg-panel
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

    gammastep = {
      Unit.Description = "Night time color filter";
      Service.ExecStart = "${pkgs.gammastep}/bin/gammastep -m wayland -l 40:-2 -t 6500:3000";
      Install.WantedBy = ["sway-session.target"];
    };

    avizo = {
      Unit.Description = "Volume popup daemon";
      Service.ExecStart = "${pkgs.avizo}/bin/avizo-service";
      Install.WantedBy = ["sway-session.target"];
    };
  };

  xdg.configFile."avizo/config.ini".source = ./avizo.ini;
}
