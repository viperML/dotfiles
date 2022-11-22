{
  pkgs,
  config,
  lib,
  ...
}: {
  services.xserver.videoDrivers = ["nvidia"];

  environment.sessionVariables = lib.mkMerge [
    {
      LIBVA_DRIVER_NAME = "nvidia";
    }
    (lib.mkIf config.viper.isWayland {
      WLR_NO_HARDWARE_CURSORS = "1";
      # WLR_RENDERER = "vulkan"; # crashes sway
      GBM_BACKEND = "nvidia-drm";
      __GL_GSYNC_ALLOWED = "0";
      __GL_VRR_ALLOWED = "0";
      __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    })
  ];

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
    Option         "UseNvKmsCompositionPipeline" "false"
    Option         "metamodes" "nvidia-auto-select +0+0 {ForceCompositionPipeline=On,AllowGSYNCCompatible=On}"
  '';
  # Option         "AllowIndirectGLXProtocol" "off"
  # Option         "TripleBuffer" "on"
}
