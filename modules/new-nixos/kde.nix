{
  pkgs,
  lib,
  config,
  ...
}: {
  services.xserver = {
    enable = true;
    desktopManager.plasma5 = {
      enable = true;
      runUsingSystemd = true;
    };
    displayManager = {
      sddm.enable = true;
      defaultSession = "plasmawayland";
      autoLogin.enable = false;
    };
  };

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    MOZ_ENABLE_WAYLAND = "1";
  };

  environment.systemPackages = [
    config.inputs.self.packages.reversal-kde
  ];

  # environment.systemPackages = lib.attrValues {
  #   inherit
  #     (pkgs.plasma5Packages)
  #     ark
  #     dolphin-plugins
  #     ffmpegthumbs
  #     gwenview
  #     kcolorchooser
  #     kdegraphics-thumbnailers
  #     kio
  #     kio-extras
  #     plasma-pa
  #     qttools
  #     skanlite
  #     ;

  #   inherit
  #     (packages.self)
  #     adw-gtk3
  #     lightly
  #     reversal-kde
  #     sierrabreezeenhanced
  #     ;
  # };
}