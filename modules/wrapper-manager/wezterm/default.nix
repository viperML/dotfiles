{
  pkgs,
  ...
}:
{
  wrappers.wezterm =
    let
      smart-splits = (pkgs.callPackages ../neovim/_sources/generated.nix { }).smart-splits-nvim.src;
    in
    {
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

            dofile("${smart-splits}/plugin/init.lua").apply_to_config(config, {
              direction_keys = { "LeftArrow", "DownArrow", "UpArrow", "RightArrow" },
              modifiers = {
                move = "CTRL",
                resize = "SHIFT|CTRL",
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
