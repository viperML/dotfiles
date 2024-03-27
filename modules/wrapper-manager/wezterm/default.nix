{ pkgs, ... }: {
  wrappers.wezterm = {
    basePackage = pkgs.wezterm;
    env.WEZTERM_CONFIG_FILE.value = ./wezterm.lua;
  };
}
