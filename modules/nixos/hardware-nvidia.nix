{
  pkgs,
  config,
  lib,
  ...
}: {
  services.xserver.videoDrivers = ["nvidia"];

  hardware = {
    nvidia.modesetting.enable = true;
    nvidia.package = let
      nv = config.boot.kernelPackages.nvidiaPackages;
    in
      if lib.versionAtLeast nv.stable.version nv.beta.version
      then nv.stable
      else nv.beta;
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
}
