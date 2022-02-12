{ config
, pkgs
, ...
}:
{
  home.packages = with pkgs; [ wezterm lua ];
}
