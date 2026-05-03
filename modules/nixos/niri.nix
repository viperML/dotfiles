{
  imports = [
    ./wayland-compositors.nix
  ];

  maid.sharedModules = [
    ../maid/niri
  ];

  programs.niri = {
    enable = true;
  };

  programs.uwsm.waylandCompositors = {
    niri = {
      prettyName = "Niri";
      comment = "Hyprland compositor managed by UWSM";
      binPath = "/run/current-system/sw/bin/niri-session";
    };
  };

  services.displayManager.defaultSession = "niri-uwsm";
}
