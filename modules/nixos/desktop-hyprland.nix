{
  inputs,
  pkgs,
  packages,
  lib,
  ...
}: {
  programs.hyprland = {
    enable = true;
    package = packages.hyprland.default.override {
      nvidiaPatches = true;
    };
  };
  services.xserver = {
    enable = true;
    displayManager = {
      lightdm.enable = false;
      sddm.enable = true;
    };
  };

  environment.sessionVariables = {
    CLUTTER_BACKEND = "wayland";
    XDG_SESSION_TYPE = "wayland";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
    MOZ_ENABLE_WAYLAND = "1";
    QT_QPA_PLATFORM = "wayland;xcb";
    GDK_BACKEND = "wayland";
    _JAVA_AWT_WM_NONREPARENTING = "1";
    XCURSOR_SIZE = "24";
    NIXOS_OZONE_WL = "1";
  };

  environment.systemPackages =
    lib.attrValues
    {
      inherit
        (pkgs.libsForQt5)
        dolphin
        ark
        gwenview

        dolphin-plugins
        ffmpegthumbs
        kdegraphics-thumbnailers
        kio
        kio-extras
        qtwayland
        ;
    };
}
