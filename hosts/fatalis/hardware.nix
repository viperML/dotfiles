{
  config,
  lib,
  pkgs,
  ...
}: let
  luksDevice = "luksroot";
in {
  boot = {
    lanzaboote = {
      enable = true;
      pkiBundle = "/etc/secureboot";
    };

    kernelPackages = pkgs.linuxPackages_latest;

    initrd = {
      systemd.enable = true;
      availableKernelModules = [
      ];

      luks = {
        devices.${luksDevice} = {
          device = "/dev/disk/by-partlabel/LINUX_LUKS";
        };
      };
    };

    # kernel.sysctl = {
    #   "vm.swappiness" = 10;
    # };

    kernelParams = [
    ];

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

  fileSystems = let
    mkTmpfs = {
      device = "none";
      fsType = "tmpfs";
      options = [
        "size=2G"
        "mode=0755"
      ];
      neededForBoot = true;
    };
  in {
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

    # "/etc" = mkTmpfs;
    # "/var" = mkTmpfs;
    "/bin" = mkTmpfs;
    "/lib64" = mkTmpfs;
    "/opt" = mkTmpfs;
    "/srv" = mkTmpfs;
    "/usr" = mkTmpfs;
  };

  # swapDevices = [
  #   {
  #     device = "/dev/disk/by-partlabel/LINUX_SWAP";
  #   }
  # ];
  security.tpm2 = {
    enable = true;
  };
}
