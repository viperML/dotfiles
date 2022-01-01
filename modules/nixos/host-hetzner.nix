{ config, pkgs, modulesPath, ... }:

{
  boot = {
    initrd = {
      availableKernelModules = [ "ahci" "xhci_pci" "virtio_pci" "sd_mod" "sr_mod" ];
      kernelModules = [ ];
    };
    kernelModules = [ ];
    extraModulePackages = [ ];

    loader = {
      grub = {
        enable = true;
        device = "/dev/sda";
      };
    };
  };

  networking.useDHCP = false;
  networking.interfaces.enp1s0.useDHCP = true;

  imports = [
    (modulesPath + "/profiles/qemu-guest.nix")
  ];

  fileSystems."/" =
    {
      device = "/dev/disk/by-label/LINUXROOT";
      fsType = "btrfs";
      options = [ "subvol=@rootfs" ];
    };

  fileSystems."/nix" =
    {
      device = "/dev/disk/by-label/LINUXROOT";
      fsType = "btrfs";
      options = [ "subvol=@nix" ];
    };

  fileSystems."/var/lib/minecraft" =
    {
      device = "/dev/disk/by-label/LINUXROOT";
      fsType = "btrfs";
      options = [ "subvol=@minecraft" ];
    };

  fileSystems."/boot" =
    {
      device = "/dev/disk/by-label/LINUXBOOT";
      fsType = "ext4";
    };

  swapDevices = [ ];
}
