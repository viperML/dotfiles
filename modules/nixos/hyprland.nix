{config, pkgs,...}: {
  imports = [
    ./wayland-compositors.nix
  ];

  maid.sharedModules = [
    ../maid/hyprland
  ];

  services.displayManager.defaultSession = "hyprland-uwsm";

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };
}
