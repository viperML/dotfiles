{inputs, ...}: {
  programs.hyprland = {
    enable = true;
    extraPackages = [];
  };
  services.xserver = {
    enable = true;
    displayManager = {
      gdm.enable = true;
    };
  };
}
