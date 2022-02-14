{ config
, pkgs
, ...
}:
{
  xdg.configFile."sway/config".source = ./config.ini;
}
