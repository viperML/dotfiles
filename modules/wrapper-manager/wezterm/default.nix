{
  pkgs,
  ...
}:
{
  wrappers.wezterm = {
    basePackage = pkgs.wezterm;
    # basePackage = inputs'.wezterm.packages.default;
    env.WEZTERM_CONFIG_FILE.value =
      pkgs.writeText "wezterm.lua"
        # lua
        ''
          local wezterm = require("wezterm")
          local config = wezterm.config_builder()

          dofile("${./viper/init.lua}").apply_to_config(config)
          dofile("${./viper/linux.lua}").apply_to_config(config)

          dofile("${pkgs.vimPlugins.smart-splits-nvim}/plugin/init.lua").apply_to_config(config, {
            -- direction_keys = { "LeftArrow", "DownArrow", "UpArrow", "RightArrow" },
            direction_keys = { "LeftArrow", "DownArrow", "UpArrow", "RightArrow" },
            modifiers = {
              move = "ALT",
              resize = "SHIFT|ALT",
            },
          })

          return config
        '';

    env.WEZTERM_CONFIG_FILE.force = true;

    env.WEZTERM_LOG.value = builtins.concatStringsSep "," [
      "window::os::wayland::window=off"
      "info"
    ];
  };
}
