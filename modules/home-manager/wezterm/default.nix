{
  config,
  pkgs,
  ...
}: {
  home.packages = [pkgs.wezterm pkgs.lua];

  xdg.configFile."wezterm/wezterm.lua".source = ./wezterm.lua;
}
