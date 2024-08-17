{
  inputs',
  inputs,
  ...
}: {
  imports = [./wayland-compositors.nix];

  programs.hyprland = {
    enable = true;
    # package = inputs'.hyprland.packages.default;
  };

  home-manager.sharedModules = [
    inputs.self.homeModules.hyprland
  ];

  # environment.sessionVariables = {
  #   XDG_CURRENT_DESKTOP = "Hyprland";
  #   XDG_SESSION_TYPE = "wayland";
  #   XDG_SESSION_DESKTOP = "Hyprland";
  # };
}
