{
  config,
  pkgs,
  lib,
  ...
}: {
  wayland.windowManager.sway = {
    enable = true;
    systemdIntegration = true;
    config = import ./config.nix {inherit pkgs lib;};
  };

  home.packages = [
    pkgs.wofi
    pkgs.plasma5Packages.dolphin
  ];
}
