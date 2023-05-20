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
    package = packages.self.hyprland;
  };

  home-manager.sharedModules = [
    inputs.self.homeModules.hyprland
  ];
}
