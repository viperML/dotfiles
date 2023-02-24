{
  pkgs,
  packages,
  lib,
  inputs,
  ...
}: {
  imports = [
    inputs.hyprland.nixosModules.default
  ];

  programs.hyprland = {
    enable = true;
    package = packages.self.hyprland;
  };

  services.xserver = {
    enable = true;
    displayManager = {
      sddm.enable = true;
    };
  };

  services.gnome.gnome-keyring.enable = true;

  services.blueman.enable = true;

  environment.systemPackages = [
    pkgs.gnome.seahorse
  ];

  # environment.sessionVariables = {
  #   NIXOS_OZONE_WL = "1";
  # };

  # environment.systemPackages =
  #   lib.attrValues
  #   {
  #     inherit
  #       (pkgs.libsForQt5)
  #       dolphin
  #       ark
  #       gwenview
  #       dolphin-plugins
  #       ffmpegthumbs
  #       kdegraphics-thumbnailers
  #       kio
  #       kio-extras
  #       qtwayland
  #       ;
  #   };
}
