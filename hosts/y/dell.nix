{ pkgs, ... }:
{
  boot.kernelPackages = pkgs.linuxPackages_latest;

  hardware = {
    graphics.extraPackages = [
      pkgs.intel-media-driver
      pkgs.intel-compute-runtime
      pkgs.vpl-gpu-rt
    ];

    ipu6 = {
      enable = true;
      platform = "ipu6epmtl";
    };
  };

  boot = {
    kernelParams = [
      "i915.force_probe=!7d45"
      "xe.force_probe=7d45"
    ];

    initrd.extraFirmwarePaths = [
      "iwlwifi-gl-c0-fm-c0-101.ucode.zst"
      "iwlwifi-gl-c0-fm-c0-100.ucode.zst"
    ];
  };
}
