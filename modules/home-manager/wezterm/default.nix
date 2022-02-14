{ config
, pkgs
, ...
}:
{
  home.packages = with pkgs; [ wezterm lua ];

  xdg.configFile."wezterm/wezterm.lua".source = ./wezterm.lua;
}
