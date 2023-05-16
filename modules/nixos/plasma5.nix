{
  packages,
  lib,
  ...
}: {
  system.nixos.label = lib.mkAfter "kde";

  services.xserver = {
    enable = true;
    desktopManager.plasma5 = {
      enable = true;
      runUsingSystemd = true;
    };
    displayManager = {
      sddm.enable = true;
      defaultSession = "plasmawayland";
    };
  };

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    MOZ_ENABLE_WAYLAND = "1";
  };

  environment.systemPackages = [
    packages.self.reversal-kde
    packages.self.papirus-icon-theme
  ];
}
