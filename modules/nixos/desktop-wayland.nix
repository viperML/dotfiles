{pkgs, ...}: {
  viper.env = {
    WLR_NO_HARDWARE_CURSORS = "1";
    _JAVA_AWT_WM_NONREARENTING = "1";
    MOZ_ENABLE_WAYLAND = "1";
    QT_QPA_PLATFORM = "wayland";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
  };

  environment.systemPackages = [
    pkgs.qt5.qtwayland
  ];
}
