{pkgs, ...}: {
  wrappers.wezterm = {
    basePackage = pkgs.wezterm;
    env.WEZTERM_CONFIG_FILE.value =
      pkgs.writeText "wezterm.lua"
      # lua
      ''
        local wezterm = require("wezterm")
        local config = wezterm.config_builder()

        dofile("${./init.lua}").apply_to_config(config)
        dofile("${./linux.lua}").apply_to_config(config)

        return config
      '';
    env.WEZTERM_CONFIG_FILE.force = true;
  };
}
