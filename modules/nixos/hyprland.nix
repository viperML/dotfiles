{
  packages,
  inputs,
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

  home-manager.sharedModules = [
    inputs.self.homeModules.hyprland
  ];
}
