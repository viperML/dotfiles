{
  pkgs,
  lib,
  packages,
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
      defaultSession =
        if config.viper.isWayland
        then "plasmawayland"
        else "plasma";
      autoLogin.enable = true;
    };
  };

  environment.sessionVariables = lib.mkMerge [
    # {
    #   KWIN_TRIPLE_BUFFER = "1";
    #   __GL_MaxFramesAllowed = "1";
    #   __GL_YIELD = "USLEEP";
    # }
    (lib.mkIf config.viper.isWayland {
      NIXOS_OZONE_WL = "1";
      MOZ_ENABLE_WAYLAND = "1";
    })
  ];

  environment.systemPackages = lib.attrValues {
    inherit
      (pkgs.plasma5Packages)
      ark
      dolphin-plugins
      ffmpegthumbs
      gwenview
      kcolorchooser
      kdegraphics-thumbnailers
      kio
      kio-extras
      plasma-pa
      qttools
      skanlite
      ;
      
    inherit
      (packages.self)
      adw-gtk3
      lightly
      reversal-kde
      sierrabreezeenhanced
      bismuth
      ;
  };
}
