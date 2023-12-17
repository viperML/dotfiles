{
  config,
  lib,
  pkgs,
  ...
}: let
  luksDevice = "luksroot";
in {
  boot = {
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
      systemd-boot = {
        enable = true;
        editor = false;
        configurationLimit = 10;
        consoleMode = "max";
      };
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/efi";
      };
      timeout = 1;
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
      device = builtins.throw "EFI partition";
      fsType = "vfat";
      options = [
        "x-systemd.automount"
        "x-systemd.mount-timeout=15min"
        "umask=077"
      ];
    };

    "/etc" = mkTmpfs;
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
}
