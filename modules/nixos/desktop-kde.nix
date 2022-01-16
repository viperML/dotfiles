{ config, pkgs, lib, ... }:

{
  services.xserver = {
    desktopManager.plasma5 = {
      enable = true;
      runUsingSystemd = true;
    };
    displayManager.defaultSession = "plasma";
  };

  environment.systemPackages = with pkgs; [
    # Theming
    lightly
    sierrabreezeenhanced

    # Extend
    libsForQt5.bismuth
    libsForQt5.plasma-pa
    libsForQt5.ark
    libsForQt5.ffmpegthumbs
    libsForQt5.kdegraphics-thumbnailers
    libsForQt5.filelight
    libsForQt5.gwenview
    libsForQt5.kwalletmanager
    caffeine-ng
    reversal-kde
  ];
}
