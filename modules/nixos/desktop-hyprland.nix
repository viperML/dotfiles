{
  pkgs,
  lib,
  packages,
  inputs,
  ...
}: let
  env = {
    _JAVA_AWT_WM_NONREARENTING = "1";
    EGL_PLATFORM = "wayland";
    LIBVA_DRIVER_NAME = "nvidia";
    MOZ_DISABLE_RDD_SANDBOX = "1";
    MOZ_ENABLE_WAYLAND = "1";
    NIXOS_OZONE_WL = "1";
    QT_QPA_PLATFORM = "wayland";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
    SDL_VIDEODRIVER = "wayland";
    WLR_DRM_NO_ATOMIC = "1";
    WLR_NO_HARDWARE_CURSORS = "1";
    # #
    __GL_GSYNC_ALLOWED = "0";
    __GL_VRR_ALLOWED = "0";
    QT_AUTO_SCREEN_SCALE_FACTOR = "1";
    GDK_BACKEND = "wayland";
    GBM_BACKEND = "nvidia-drm";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
  };
in {
  imports = [inputs.hyprland.nixosModules.default];
  programs.hyprland.enable = true;
  services.xserver = {
    # enable = true;
    displayManager.gdm = {
      enable = true;
      wayland = true;
    };
  };

  environment.variables = env;
  environment.sessionVariables = env;
}
