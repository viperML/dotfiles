{
  packages,
  inputs,
  ...
}: {
  imports = [
    ./wayland-compositors.nix
  ];

  programs.hyprland = {
    enable = true;
    package = packages.hyprland.default;
  };

  home-manager.sharedModules = [
    inputs.self.homeModules.hyprland
  ];
}
