{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    wofi
  ];

  wayland.windowManager.sway = {
    enable = true;
    config.terminal = "${pkgs.g-kitty}";
    systemdIntegration = true;
    extraOptions = [
      "--unsupported-gpu"
    ];
    extraSessionCommands = ''
      export MOZ_ENABLE_WAYLAND=1
      export QT_QPA_PLATFORM=wayland
      export QT_WAYLAND_DISABLE_WINDOWDECORATION="1"
      export SDL_VIDEODRIVER=wayland
      export XDG_CURRENT_DESKTOP="sway"
      export XDG_SESSION_TYPE="wayland"
      export _JAVA_AWT_WM_NONREPARENTING=1
      export GBM_BACKEND=nvidia-drm
      export GBM_BACKENDS_PATH=/etc/gbm
      export __GLX_VENDOR_LIBRARY_NAME=nvidia
      export WLR_NO_HARDWARE_CURSORS=1
    '';
  };
}
