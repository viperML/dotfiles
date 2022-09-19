{
  pkgs,
  config,
  lib,
  ...
}: {
  services.xserver.videoDrivers = ["nvidia"];

  environment.sessionVariables = {
    LIBVA_DRIVER_NAME = "nvidia";
    WLR_NO_HARDWARE_CURSORS = "1";
    # https://forums.developer.nvidia.com/t/the-situation-on-kde-kwin-plasma-performance/57811/35
    KWIN_TRIPLE_BUFFER = "1";
    __GL_MaxFramesAllowed = "1";
    WLR_RENDERER = "vulkan"; # only affects sway
  };

  hardware = {
    nvidia.modesetting.enable = true;
    nvidia.package = let
      nv = config.boot.kernelPackages.nvidiaPackages;
    in
      if lib.versionAtLeast nv.stable.version nv.beta.version
      then nv.stable
      else nv.beta;
    nvidia.powerManagement.enable = true;
    opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
      extraPackages = with pkgs; [
        vaapiVdpau
        libvdpau-va-gl
        nvidia-vaapi-driver
      ];
      extraPackages32 = with pkgs.pkgsi686Linux; [
        vaapiVdpau
        libvdpau-va-gl
        nvidia-vaapi-driver
      ];
    };
  };

  services.xserver.screenSection = ''
    Option         "metamodes" "nvidia-auto-select +0+0 {ForceCompositionPipeline=On}"
    Option         "AllowIndirectGLXProtocol" "off"
    Option         "TripleBuffer" "on"
  '';
}
