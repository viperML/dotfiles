{
  swapDevices = [
    {
      device = "/swapfile";
      size = 4096;
    }
  ];

  zramSwap = {enable = true;};
}
