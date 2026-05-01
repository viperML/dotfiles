{
  imports = [
    ../wayland-compositors
  ];

  file.xdg_config."niri/config.kdl".source = builtins.toString ./config.kdl;
}
