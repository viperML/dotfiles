{
  boot.kernelParams = [
    "quiet"
    "systemd.show_status=auto"
    "rd.udev.log_level=3"
    "plymouth.use-simpledrm"
  ];

  boot.plymouth = {
    enable = true;
  };

  boot.loader.timeout = 0;
}
