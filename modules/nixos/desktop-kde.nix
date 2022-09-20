{
  config,
  pkgs,
  lib,
  packages,
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
      defaultSession = "plasma";
      # autoLogin.enable = true;
    };
  };

  environment.sessionVariables = {
    KWIN_TRIPLE_BUFFER = "1";
    __GL_MaxFramesAllowed = "1";
    __GL_YIELD = "USLEEP";
  };

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

  environment.etc."chromium/native-messaging-hosts/org.kde.plasma.browser_integration.json".source = "${pkgs.plasma-browser-integration}/etc/chromium/native-messaging-hosts/org.kde.plasma.browser_integration.json";
}
