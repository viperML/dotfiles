{ config, pkgs, modulesPath, ... }:

{
  boot = {
    initrd = {
      availableKernelModules = [ "ahci" "xhci_pci" "virtio_pci" "sd_mod" "sr_mod" ];
      kernelModules = [ ];
    };
    kernelModules = [ ];
    extraModulePackages = [ ];
    loader.systemd-boot.enable = true;
  };

  networking.useDHCP = false;
  networking.interfaces.enp1s0.useDHCP = true;

  imports = [
    (modulesPath + "/profiles/qemu-guest.nix")
  ];

  fileSystems."/" =
    {
      device = "/dev/sda2";
      fsType = "btrfs";
      options = [ "subvol=@rootfs" ];
    };

  fileSystems."/nix" =
    {
      device = "/dev/sda2";
      fsType = "btrfs";
      options = [ "subvol=@nix" ];
    };

  fileSystems."/var/lib/minecraft" =
    {
      device = "/dev/sda2";
      fsType = "btrfs";
      options = [ "subvol=@minecraft" ];
    };

  fileSystems."/boot" =
    {
      device = "/dev/disk/by-uuid/4C74-8154";
      fsType = "vfat";
    };

  swapDevices = [ ];
}
