{ config, pkgs, ... }:

{
  services = {
    xserver = {
      displayManager = {
        sddm.enable = true;
        sddm.autoLogin.relogin = true;
      };
      desktopManager.plasma5.enable = true;
      desktopManager.plasma5.runUsingSystemd = true;
    };
  };

  environment.systemPackages = with pkgs; [
    libsForQt5.bismuth
    libsForQt5.plasma-pa
    libsForQt5.qtstyleplugin-kvantum
    lightly
    sierrabreezeenhanced
    libsForQt5.ark
    libsForQt5.ffmpegthumbs
    libsForQt5.kdegraphics-thumbnailers
    libsForQt5.filelight
    libsForQt5.gwenview
    libsForQt5.kwalletmanager
    caffeine-ng
  ];
}
