{ pkgs, packages, ... }: {
  services.xserver = {
    desktopManager.plasma6.enable = true;
    displayManager = {
      sddm.enable = true;
      defaultSession = "plasma";
    };
  };

  environment.sessionVariables = {
    MOZ_ENABLE_WAYLAND = "1";
  };

  environment.systemPackages = [
    packages.self.papirus-icon-theme
    # packages.self.adw-gtk3
    pkgs.vanilla-dmz
  ];
}
