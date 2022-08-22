{
  pkgs,
  lib,
  packages,
  ...
}: {
  services.xserver = {
    enable = true;
    displayManager."gdm".enable = true;
    windowManager.awesome = {
      enable = true;
      package = packages.self.awesome;
    };
  };

  services.autorandr.enable = true;

  programs.ssh.askPassword = "${pkgs.gnome.seahorse}/libexec/seahorse/ssh-askpass";

  environment.variables.QT_QPA_PLATFORMTHEME = "gnome";

  xdg.portal = {
    enable = true;
    extraPortals = [
      pkgs.plasma5Packages.xdg-desktop-portal-kde
    ];
  };

  environment.systemPackages =
    lib.attrValues
    {
      inherit
        (pkgs)
        qgnomeplatform
        adwaita-qt
        ;
      inherit
        (pkgs.plasma5Packages)
        dolphin
        ark
        # Everything I tried to get thumbnails working

        dolphin-plugins
        ffmpegthumbs
        kdegraphics-thumbnailers
        kio
        kio-extras
        #

        gwenview
        kwallet
        kwalletmanager
        ;
    };
}
