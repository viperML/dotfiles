{config, ...}: {
  services.xserver.videoDrivers = ["modesetting" "nvidia"];

  hardware.nvidia = {
    powerManagement = {
      enable = true;
      finegrained = config.hardware.nvidia.prime.offload.enable;
    };
    prime = {
      nvidiaBusId = "PCI:1:0:0";
      intelBusId = "PCI:0:2:0";
    };
  };
}
