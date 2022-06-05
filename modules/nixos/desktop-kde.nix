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
      ;
    # inherit
    #   (pkgs)
    #   ;
    inherit
      (packages.self)
      adw-gtk3
      lightly
      lightlyshaders
      reversal-kde
      sierrabreezeenhanced
      ;
  };

  programs.xwayland.enable = true;
}
