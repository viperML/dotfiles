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
      gdm.enable = true;
      sddm.enable = false;
      defaultSession = "plasma";
      autoLogin.enable = true;
    };
  };

  environment.systemPackages = lib.attrValues {
    inherit
      (pkgs.plasma5Packages)
      bismuth
      plasma-pa
      ark
      ffmpegthumbs
      kdegraphics-thumbnailers
      gwenview
      kcolorchooser
      qttools
      ;
    inherit
      (pkgs)
      plasma-browser-integration
      ;
    inherit
      (packages.self)
      adw-gtk3
      lightly
      reversal-kde
      sierrabreezeenhanced
      ;
  };

  environment.etc."chromium/native-messaging-hosts/org.kde.plasma.browser_integration.json".source = "${pkgs.plasma-browser-integration}/etc/chromium/native-messaging-hosts/org.kde.plasma.browser_integration.json";

  programs.xwayland.enable = true;
}
