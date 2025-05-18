{
  inputs,
  ...
}: {
  imports = [./wayland-compositors.nix];

  programs.hyprland = {
    enable = true;
  };

  home-manager.sharedModules = [
    inputs.self.homeModules.hyprland
  ];

  # environment.sessionVariables = {
  #   XDG_CURRENT_DESKTOP = "Hyprland";
  #   XDG_SESSION_TYPE = "wayland";
  #   XDG_SESSION_DESKTOP = "Hyprland";
  # };

  services.gnome.gnome-keyring.enable = true;
  services.gnome.at-spi2-core.enable = true;
}
