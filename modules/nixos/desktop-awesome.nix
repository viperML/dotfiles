{
  pkgs,
  lib,
  ...
}: {
  services.xserver = {
    enable = true;
    displayManager.gdm.enable = true;
    displayManager.autoLogin.enable = true;
    windowManager.awesome = {
      enable = true;
      luaModules = with pkgs.luaPackages; [
        #keep
      ];
    };
  };

  services.autorandr.enable = true;
  hardware.nvidia.modesetting.enable = true;

  programs.ssh.askPassword = "${pkgs.gnome.seahorse}/libexec/seahorse/ssh-askpass";

  environment.variables.QT_QPA_PLATFORMTHEME = "gnome";

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
        # Everything I tried to get thumbnails working
        
        dolphin-plugins
        ffmpegthumbs
        kdegraphics-thumbnailers
        kio
        kio-extras
        #
        
        gwenview
        ;
    };
}
