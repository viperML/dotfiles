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
      (pkgs.plasma5Packages)
      bismuth
      plasma-pa
      ark
      ffmpegthumbs
      kdegraphics-thumbnailers
      filelight
      gwenview
      kcolorchooser
      # kwalletmanager
      
      plasma-disks
      ;
    inherit
      (pkgs)
      lxappearance
      ;
    inherit
      (packages.self)
      adw-gtk3
      lightly
      lightlyshaders
      reversal-kde
      sierrabreezeenhanced
      # bismuth
      
      ;
  };

  programs = {
    xwayland.enable = true;
  };
}
