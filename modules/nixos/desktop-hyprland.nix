{inputs, ...}: {
  programs.hyprland = {
    enable = true;
  };
  services.xserver = {
    enable = true;
    displayManager = {
      gdm.enable = true;
    };
  };
}
