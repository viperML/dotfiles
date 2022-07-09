{inputs, ...}: {
  programs.hyprland = {
    enable = true;
    extraPackages = [];
  };
  services.xserver = {
    enable = true;
    displayManager = {
      gdm.enable = true;
    };
  };

  viper.env = {
    WLR_NO_HARDWARE_CURSORS = "1";
    _JAVA_AWT_WM_NONREARENTING = "1";
    # Rando yt video
    __GL_GSYNC_ALLOWED = "0";
    __GL_VRR_ALLOWED = "0";
    WLR_DRM_NO_ATOMIC = "0";
    QT_AUTO_SCREEN_SCALE_FACTOR = "1";
    QT_QPA_PLATFORM = "wayland";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
    GDK_BACKEND = "wayland";
    XDG_CURRENT_DESKTOP = "sway";
    GBM_BACKEND = "nvidia-drm";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    MOZ_ENABLE_WAYLAND = "1";
  };
}
