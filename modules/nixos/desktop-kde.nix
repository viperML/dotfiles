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
    displayManager.sddm.enable = true;
    displayManager.defaultSession = "plasma";
    displayManager.autoLogin.enable = true;
  };

  environment.systemPackages = lib.attrValues {
    inherit
      (pkgs.libsForQt5)
      bismuth
      plasma-pa
      ark
      ffmpegthumbs
      kdegraphics-thumbnailers
      filelight
      gwenview
      kcolorchooser
      kwalletmanager
      ;
    inherit
      (pkgs)
      latte-dock
      ;
    inherit
      (packages.self)
      adw-gtk3
      kwin-forceblur
      lightly
      lightlyshaders
      reversal-kde
      sierrabreezeenhanced
      ;
  };

  programs = {
    xwayland.enable = true;
  };
}
