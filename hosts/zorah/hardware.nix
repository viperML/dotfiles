{ config
, lib
, pkgs
, ...
}:
let
  luksDevice = "luksroot";
  swapfile = "/swapfile";
in
{
  boot = {
    lanzaboote = {
      enable = true;
      pkiBundle = "/var/lib/secrets/secureboot";
    };

    kernelPackages = pkgs.linuxPackages_latest;

    initrd = {
      systemd.enable = true;
      availableKernelModules = [
        "xhci_pci"
        "thunderbolt"
        "vmd"
        "nvme"
        "usb_storage"
        "sd_mod"
        "rtsx_pci_sdmmc"
      ];

      luks = {
        devices.${luksDevice} = {
          device = "/dev/disk/by-partlabel/LINUX_LUKS";
        };
      };
    };

    kernel.sysctl = {
      # "vm.swappiness" = 100;
    };

    kernelParams = [
    ];

    kernelModules = [ "kvm-intel" ];

    loader = {
      systemd-boot.enable = lib.mkForce false;
      grub.enable = lib.mkForce false;
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot";
      };
      # timeout = 1;
    };

    tmp.useTmpfs = true;
  };

  fileSystems =
    let
      mkTmpfs = {
        device = "none";
        fsType = "tmpfs";
        options = [
          "size=2G"
          "mode=0755"
        ];
        neededForBoot = true;
      };
    in
    {
      "/" = {
        device = "/dev/mapper/${luksDevice}";
        fsType = "xfs";
        options = [
          "noatime"
        ];
      };

      ${config.boot.loader.efi.efiSysMountPoint} = {
        device = "/dev/disk/by-partlabel/ESP";
        fsType = "vfat";
        options = [
          "x-systemd.automount"
          "x-systemd.mount-timeout=15min"
          "umask=077"
        ];
      };

      "/etc" = mkTmpfs;
      # "/var" = mkTmpfs;
      "/bin" = mkTmpfs;
      "/lib64" = mkTmpfs;
      "/opt" = mkTmpfs;
      "/srv" = mkTmpfs;
      "/usr" = mkTmpfs;
    };

  security.tpm2 = {
    enable = true;
  };

  systemd.tmpfiles.rules =
    let
      persist = "/var/lib/NetworManager-system-connections";
    in
    [
      "d ${persist} 0700 root root - -"
      "z ${persist} 0700 root root - -"
      "L /etc/NetworkManager/system-connections - - - - ${persist}"
    ];
}
