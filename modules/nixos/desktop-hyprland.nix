{
  inputs,
  pkgs,
  packages,
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
    QT_QPA_PLATFORM = "wayland";
    GDK_BACKEND = "wayland";
    _JAVA_AWT_WM_NONREPARENTING = "1";
    XCURSOR_SIZE = "24";
  };

  # TODO only for nvidia
  # boot.extraModprobeConfig = ''
  #   options nvidia NVreg_RegistryDwords="PowerMizerEnable=0x1; PerfLevelSrc=0x2222; PowerMizerLevel=0x3; PowerMizerDefault=0x3; PowerMizerDefaultAC=0x3"
  # '';
}
