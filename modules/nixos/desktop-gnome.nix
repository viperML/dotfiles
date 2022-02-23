{
  config,
  pkgs,
  lib,
  ...
}: let
  my-extensions = builtins.attrValues {
    inherit
      (pkgs.gnomeExtensions)
      appindicator
      blur-my-shell
      pop-shell
      # night-theme-switcher
      dash-to-panel
      sound-output-device-chooser
      system-monitor
      logo-menu
      syncthing-indicator
      ;
  };
in {
  services.xserver = {
    desktopManager.gnome.enable = true;
    displayManager.gdm = {
      enable = true;
      wayland = false;
    };
    displayManager.defaultSession = "gnome-xorg";
    displayManager.autoLogin.enable = true;
  };

  environment.gnome.excludePackages = builtins.attrValues {
    inherit
      (pkgs)
      epiphany
      gnome-photos
      # evince
      gnome-tour
      ;
    inherit
      (pkgs.gnome)
      gnome-characters
      cheese
      gnome-terminal
      gedit
      totem
      geary
      gnome-screenshot
      eog
      ;
  };

  environment.systemPackages =
    (builtins.attrValues
    {
      inherit
        (pkgs)
        adw-gtk3
        ;
      inherit
        (pkgs.gnome)
        gnome-tweaks
        gnome-shell-extensions
        dconf-editor
        ;
      inherit
        (pkgs.libsForQt5)
        gwenview
        ;
    })
    ++ my-extensions;
}
