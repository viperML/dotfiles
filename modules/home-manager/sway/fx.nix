{...}: {
  wayland.windowManager.sway.extraConfig = ''
    corner_radius 5

    shadows enable
    shadow_blur_radius 10
    shadow_color #000000DD
  '';
}
