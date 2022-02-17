{
  config,
  pkgs,
  ...
}:
let
  waylandEnv = rec {
    WLR_NO_HARDWARE_CURSORS = "1";
    NIXOS_OZONE_WL = "1";
    GTK_USE_PORTAL = "1";
    CLUTTER_BACKEND = "wayland";
    SDL_VIDEODRIVER = "wayland";
    _JAVA_AWT_WM_NONREARENTING = "1";

    MOZ_ENABLE_WAYLAND = "1";
    MOZ_WEBRENDER = "0";

    QT_QPA_PLATFORM = "wayland";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";

    XDG_CURRENT_DESKTOP = "sway";
    XDG_SESSION_TYPE = "wayland";
    XDG_SESSION_DESKTOP = "sway";
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
}
