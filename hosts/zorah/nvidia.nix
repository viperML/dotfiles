{
  config,
  pkgs,
  ...
}: {
  services.xserver.videoDrivers = [
    "nvidia"
  ];

  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement = {
      enable = true;
      finegrained = config.hardware.nvidia.prime.offload.enable;
    };
    nvidiaSettings = false;
    # prime = {
    #   nvidiaBusId = "PCI:1:0:0";
    #   intelBusId = "PCI:0:2:0";
    # };
  };

  environment.systemPackages = [
    pkgs.nvtopPackages.nvidia
  ];
}
