{ config
, pkgs
, ...
}:
let
  waylandEnv = {
    WLR_NO_HARDWARE_CURSORS = "1";
    _JAVA_AWT_WM_NONREPARENTING = "1";
    MOZ_ENABLE_WAYLAND = "1";
    QT_QPA_PLATFORM = "wayland";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
    SDL_VIDEODRIVER = "wayland";
    XDG_CURRENT_DESKTOP = "sway";
    XDG_SESSION_TYPE = "wayland";
  };
in
{
  programs.sway = {
    enable = true;
    extraOptions = [ "--unsupported-gpu" ];
  };

  environment.systemPackages =
    with pkgs; [
      wofi
    ];

  environment.variables = waylandEnv;
  environment.sessionVariables = waylandEnv;
}
