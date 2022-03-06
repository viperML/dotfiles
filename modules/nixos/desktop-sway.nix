{
  pkgs,
  lib,
  ...
}: let
  # https://github.com/cole-mickens/nixcfg/blob/f62dc66e43c0efd7ed8e12189a5834b9b15834d9/mixins/gfx-nvidia.nix
  waylandEnv = rec {
    WLR_NO_HARDWARE_CURSORS = "1";
    NIXOS_OZONE_WL = "1";
    GTK_USE_PORTAL = "1";

    _JAVA_AWT_WM_NONREARENTING = "1";

    MOZ_ENABLE_WAYLAND = "1";

    QT_QPA_PLATFORM = "wayland";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";

    SDL_VIDEODRIVER = "wayland";
  };
in {
  services.xserver = {
    enable = true;
    videoDrivers = lib.mkForce ["nouveau"];
    displayManager.gdm.enable = true;
    displayManager.gdm.wayland = true;
  };

  programs.sway = {
    enable = true;
    extraOptions = ["--unsupported-gpu"];
    wrapperFeatures = {
      gtk = true;
    };
  };

  environment.systemPackages = with pkgs; [
    libsForQt5.qtwayland
    latte-dock
  ];

  environment.variables = waylandEnv;
  environment.sessionVariables = waylandEnv;
}
