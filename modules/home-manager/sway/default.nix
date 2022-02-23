{
  config,
  pkgs,
  lib,
  ...
}: {
  home.packages = [
    pkgs.wofi
    pkgs.plasma5Packages.dolphin
  ];

  # FIXME
  systemd.user.tmpfiles.rules = [
    "L+ /home/ayats/.config/sway/config - - - - /home/ayats/Documents/dotfiles/modules/home-manager/sway/config.ini"
  ];
}
