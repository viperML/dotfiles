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
      gdm.enable = false;
      sddm.enable = true;
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
      filelight
      gwenview
      kcolorchooser
      discover
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
      ;
  };

  programs.xwayland.enable = true;
}
