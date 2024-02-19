{ packages
, pkgs
, inputs
, ...
}: {
  services.xserver = {
    enable = true;
    desktopManager.plasma5 = {
      enable = true;
      runUsingSystemd = true;
    };
    displayManager = {
      defaultSession = "plasmawayland";
    };
  };

  environment.sessionVariables = {
    MOZ_ENABLE_WAYLAND = "1";
  };

  environment.systemPackages = [
    packages.self.reversal-kde
    packages.self.papirus-icon-theme
    packages.self.adw-gtk3
    pkgs.vanilla-dmz
  ];

  home-manager.sharedModules = [
    inputs.self.homeModules.plasma5
  ];
}
