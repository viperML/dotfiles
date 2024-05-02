{
  lib,
  config,
  ...
}: {
  config = lib.mkIf config.wayland.windowManager.sway.fx {
    wayland.windowManager.sway.extraConfig = ''
      corner_radius 6

      shadows enable
      shadow_blur_radius 10
      shadow_color #000000DD
    '';
  };
}
