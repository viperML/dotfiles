{...}: {
  services.xserver = {
    enable = true;
    displayManager.gdm.enable = true;
  };

  programs.sway = {
    enable = true;
    extraOptions = [
      "--unsupported-gpu"
      "-D"
      "noscanout"
    ];
    wrapperFeatures = {
      gtk = true;
    };
  };

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    MOZ_ENABLE_WAYLAND = "1";
    MOZ_USE_XINPUT2 = "1";
    QT_QPA_PLATFORM = "wayland;xcb";
    QT_WAYLAND_DISABLE_WINDOWDECORATION="1";
  };
}
