{packages, ...}: {
  services.xserver = {
    enable = true;
    displayManager.gdm.enable = true;
    displayManager.sessionPackages = [packages.self.river];
  };

  environment.systemPackages = [
    packages.self.river
    packages.self.foot
  ];

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    MOZ_ENABLE_WAYLAND = "1";
    MOZ_USE_XINPUT2 = "1";
    QT_QPA_PLATFORM = "wayland;xcb";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
  };
}
