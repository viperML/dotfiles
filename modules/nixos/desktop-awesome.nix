{pkgs, ...}: {
  services.xserver = {
    enable = true;
    displayManager.gdm.enable = true;
    displayManager.autoLogin.enable = true;
    windowManager.awesome = {
      enable = true;
      luaModules = with pkgs.luaPackages; [
        #keep
      ];
    };
  };

  # Needed for autorandr
  hardware.nvidia.modesetting.enable = true;
}
