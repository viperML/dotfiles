{ config, pkgs, lib, ... }:

{
  services.xserver = {
    desktopManager.plasma5 = {
      enable = true;
      runUsingSystemd = true;
    };
    displayManager.defaultSession = "plasma";
    displayManager.autoLogin.enable = true;
  };

  environment.systemPackages = with pkgs; [
    # Themes
    libsForQt5.lightly
    libsForQt5.sierrabreezeenhanced
    libsForQt5.reversal-kde
    yaru-theme
    adwaita-plus

    # Extend
    libsForQt5.bismuth
    libsForQt5.plasma-pa
    libsForQt5.ark
    libsForQt5.ffmpegthumbs
    libsForQt5.kdegraphics-thumbnailers
    libsForQt5.filelight
    libsForQt5.gwenview
    libsForQt5.kcolorchooser
    caffeine-ng
    libsForQt5.kwin-forceblur
    pkgs.libsForQt5.kwalletmanager
  ];

}
