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
      options = [ "subvol=@rootfs" "noatime" "compress=zstd" ];
    };

  fileSystems."/nix" =
    {
      device = "/dev/disk/by-label/LINUXROOT";
      fsType = "btrfs";
      options = [ "subvol=@nix" "noatime" "compress=zstd" ];
    };

  fileSystems."/var/lib/minecraft" =
    {
      device = "/dev/disk/by-label/LINUXROOT";
      fsType = "btrfs";
      options = [ "subvol=@minecraft" "noatime" "compress=zstd" ];
    };

  fileSystems."/boot" =
    {
      device = "/dev/disk/by-label/LINUXBOOT";
      fsType = "ext4";
    };

  # systemd.services = {
  #   create-swapfile = {
  #     serviceConfig.Type = "oneshot";
  #     wantedBy = [ "swap-swapfile.swap" ];
  #     script = ''
  #       ${pkgs.coreutils}/bin/truncate -s 0 /swap/swapfile
  #       ${pkgs.e2fsprogs}/bin/chattr +C /swap/swapfile
  #       ${pkgs.btrfs-progs}/bin/btrfs property set /swap/swapfile compression none
  #     '';
  #   };
  # };

  fileSystems."/swap" = {
    device = "/dev/disk/by-label/LINUXROOT";
    fsType = "btrfs";
    # options = [ "subvol=swap" "compress=lzo" "noatime" ]; # Note these options effect the entire BTRFS filesystem and not just this volume, with the exception of `"subvol=swap"`, the other options are repeated in my other `fileSystem` mounts
    options = [ "subvol=@swap" "noatime" "compress=zstd" ];
  };

  swapDevices = [{
    device = "/swap/swapfile";
    size = (1024 * 2) + (1024 * 2); # RAM size + 2 GB
  }];
}
