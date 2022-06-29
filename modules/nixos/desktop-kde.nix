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

  environment.systemPackages = lib.attrValues {
    inherit
      (pkgs.plasma5Packages)
      plasma-pa
      ark
      ffmpegthumbs
      kdegraphics-thumbnailers
      gwenview
      kcolorchooser
      qttools
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

  programs.xwayland.enable = true;
}
