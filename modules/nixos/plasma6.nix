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
    pkgs.vanilla-dmz
    pkgs.kdePackages.discover
  ];

  services.packagekit = {
    enable = true;
  };
}
