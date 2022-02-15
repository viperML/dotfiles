{ config
, pkgs
, lib
, ...
}:
# let
#   cfg =
#     if (lib.hasAttr "FLAKE" config.home.sessionVariables)
#     then
#       # FIXME
#     else { xdg.configFile."sway/config".source = ./config.ini; };
# in
{
  home.packages = with pkgs; [
    wofi
    plasma5Packages.dolphin
  ];

  # FIXME
  systemd.user.tmpfiles.rules = [
    "L+ /home/ayats/.config/sway/config - - - - /home/ayats/Documents/dotfiles/modules/home-manager/sway/config.ini"
  ];
}
