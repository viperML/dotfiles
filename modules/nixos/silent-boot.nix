{
  boot.kernelParams = [
    "quiet"
    "systemd.show_status=auto"
    "rd.udev.log_level=3"
    "plymouth.use-simpledrm"

    # Send logs to tty2
    "fbcon=vc:2-6"
    "console=tty0"
  ];

  boot.plymouth = {
    enable = true;
  };

  boot.loader.timeout = 0;
}
