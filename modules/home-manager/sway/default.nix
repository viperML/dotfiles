{
  config,
  pkgs,
  lib,
  ...
}: {
  home.packages = with pkgs; [
    wofi
    plasma5Packages.dolphin
  ];

  # FIXME
  systemd.user.tmpfiles.rules = [
    "L+ /home/ayats/.config/sway/config - - - - /home/ayats/Documents/dotfiles/modules/home-manager/sway/config.ini"
  ];
}
