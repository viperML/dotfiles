{
  config,
  pkgs,
  lib,
  packages,
  ...
}: {
  imports = [
    ./config.nix
    ../wayland-compositors
    ../waybar
  ];

  wayland.windowManager.sway = {
    enable = true;
    # Use NixOS module system to install
    package = null;
    systemdIntegration = true;
  };

  home.packages = [
    # pkgs.qgnomeplatform
    # pkgs.adwaita-qt
    # pkgs.wofi
    # pkgs.firefox
    # packages.self.papirus-icon-theme

    # pkgs.libsForQt5.dolphin
    # pkgs.libsForQt5.ark
    # pkgs.libsForQt5.qtwayland
    # pkgs.libsForQt5.dolphin-plugins
    # pkgs.libsForQt5.ffmpegthumbs
    # pkgs.libsForQt5.kdegraphics-thumbnailers
    # pkgs.libsForQt5.kio
    # pkgs.libsForQt5.kio-extras
    # pkgs.libsForQt5.gwenview

    packages.self.wezterm
  ];

  systemd.user.services = {
    autotiling = {
      Install.WantedBy = ["graphical-session.target"];
      Unit.Description = "Autotiling";
      Service.ExecStart = "${pkgs.autotiling-rs}/bin/autotiling-rs";
    };
  };
}
