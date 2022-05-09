{pkgs, ...}: {
  boot.initrd.systemd = {
    enable = true;
    emergencyAccess = true;
  };
}
