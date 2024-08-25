local wezterm = require("wezterm")
local config = wezterm.config_builder()

require("viper").apply_to_config(config)
require("viper.windows").apply_to_config(config)

return config
