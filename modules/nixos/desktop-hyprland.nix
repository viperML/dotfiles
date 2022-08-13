{inputs, ...}: {
  programs.hyprland = {
    enable = true;
  };
  services.xserver = {
    enable = true;
    displayManager = {
      lightdm.enable = false;
      gdm.enable = false;
    };
  };

  environment.variables = {
    # CLUTTER_BACKEND = "wayland";
    XDG_SESSION_TYPE = "wayland";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
    MOZ_ENABLE_WAYLAND = "1";
    # WLR_BACKEND = "vulkan";
    # QT_QPA_PLATFORM = "wayland";
    GDK_BACKEND = "wayland";
  };
}
