{
  config,
  pkgs,
  lib,
  ...
}: let
  # https://github.com/cole-mickens/nixcfg/blob/f62dc66e43c0efd7ed8e12189a5834b9b15834d9/mixins/gfx-nvidia.nix
  waylandEnv = rec {
    # WLR_NO_HARDWARE_CURSORS = "1";
    # NIXOS_OZONE_WL = "1";
    # GTK_USE_PORTAL = "1";
    # GDK_BACKEND = "wayland";
    # GBM_BACKEND = "nvidia";
    # _JAVA_AWT_WM_NONREARENTING = "1";

    # MOZ_ENABLE_WAYLAND = "1";

    # QT_QPA_PLATFORM = "wayland";
    # QT_AUTO_SCREEN_SCALE_FACTOR = "1";
    # QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";

    # XDG_CURRENT_DESKTOP = "sway";
    # XDG_SESSION_TYPE = "wayland";
    # XDG_SESSION_DESKTOP = "sway";
    # LIBVA_DRIVER_NAME = "nvidia";
    # MOZ_DISABLE_RDD_SANDBOX = "1";
    # EGL_PLATFORM = "wayland";
    # WLR_DRM_NO_ATOMIC = "1";
    # __GLX_VENDOR_LIBRARY_NAME = "nvidia";
  };
in {
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.displayManager.autoLogin.enable = true;

  programs.sway = {
    enable = true;
    extraOptions = ["--unsupported-gpu"];
  };

  environment.variables = waylandEnv;
  environment.sessionVariables = waylandEnv;

  environment.systemPackages = with pkgs; [
    pavucontrol
  ];
}
