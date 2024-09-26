{config, ...}: {
  boot.kernelModules = ["i2c-dev"];
  services.udev.extraRules = ''
    KERNEL=="i2c-[0-9]*", GROUP="i2c", MODE="0660"
  '';

  users.groups."i2c".members = config.users.groups.wheel.members;
}
