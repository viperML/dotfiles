{...}: {
  wayland.windowManager.sway.extraConfig = ''
    smart_corner_radius enable
    corner_radius 5

    shadows enable
    shadow_blur_radius 10
    shadow_color #000000DD
  '';
}
