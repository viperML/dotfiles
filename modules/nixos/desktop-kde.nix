{
  config,
  pkgs,
  lib,
  ...
}: let
  my-env = {
    GTK_USE_PORTAL = "1";
  };
in {
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

  environment.systemPackages = with pkgs; [
    # Theming
    libsForQt5.lightly
    libsForQt5.sierrabreezeenhanced
    libsForQt5.reversal-kde
    libsForQt5.lightlyshaders
    adw-gtk3

    # Extend
    libsForQt5.bismuth
    libsForQt5.plasma-pa
    libsForQt5.ark
    libsForQt5.ffmpegthumbs
    libsForQt5.kdegraphics-thumbnailers
    libsForQt5.filelight
    libsForQt5.gwenview
    libsForQt5.kcolorchooser
    libsForQt5.kwin-forceblur
    latte-dock
    pkgs.libsForQt5.kwalletmanager
  ];

  environment.variables = my-env;
  environment.sessionVariables = my-env;

  programs = {
    xwayland.enable = true;
  };
}
