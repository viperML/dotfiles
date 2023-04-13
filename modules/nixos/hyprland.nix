{
  packages,
  ...
}: {
  imports = [
    # inputs.hyprland.nixosModules.default
    ./wayland-compositors.nix
    ./fcitx5.nix
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
