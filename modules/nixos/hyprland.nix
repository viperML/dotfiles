{
  pkgs,
  packages,
  lib,
  inputs,
  ...
}: {
  imports = [
    inputs.hyprland.nixosModules.default
    ./wayland-compositors.nix
  ];

  programs.hyprland = {
    enable = true;
    package = packages.self.hyprland;
  };

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
