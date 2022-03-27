{
  config,
  pkgs,
  lib,
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
      lightly
      sierrabreezeenhanced
      reversal-kde
      lightlyshaders
      bismuth
      plasma-pa
      ark
      ffmpegthumbs
      kdegraphics-thumbnailers
      filelight
      gwenview
      kcolorchooser
      kwin-forceblur
      kwalletmanager
      ;
    inherit
      (pkgs)
      adw-gtk3
      latte-dock
      ;
  };

  programs = {
    xwayland.enable = true;
  };
}
