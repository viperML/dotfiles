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

  services.autorandr.enable = true;
  hardware.nvidia.modesetting.enable = true;
}
