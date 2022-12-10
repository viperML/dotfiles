{
  pkgs,
  lib,
  ...
}: {
  boot.initrd.availableKernelModules = ["amdgpu"];
  services.xserver.videoDrivers = ["amdgpu"];

  hardware.opengl.extraPackages = with pkgs; [
    rocm-opencl-icd
    rocm-opencl-runtime
    amdvlk
  ];

  hardware.opengl.extraPackages32 = with pkgs; [
    driversi686Linux.amdvlk
  ];

  hardware.opengl = {
    enable = true;
    driSupport = lib.mkDefault true;
    driSupport32Bit = lib.mkDefault true;
  };

  environment.variables.AMD_VULKAN_ICD = lib.mkDefault "RADV";
}
