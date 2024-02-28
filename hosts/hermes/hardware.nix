{ config
, lib
, pkgs
, ...
}:
let
  luksDevice = "luksroot";
in
{
  boot = {
    kernelPackages = pkgs.linuxPackages_latest;

    initrd = {
      systemd.enable = true;
      availableKernelModules = [
        "xhci_pci"
        "ahci"
        "nvme"
        "usbhid"
        "kvm-intel"
      ];
      luks = {
        devices.${luksDevice} = {
          device = "/dev/disk/by-partlabel/LINUX_LUKS";
        };
      };
    };

    # binfmt.emulatedSystems = [
    #   "aarch64-linux"
    #   "wasm32-wasi"
    # ];

    kernel.sysctl = {
      "vm.swappiness" = 10;
    };

    kernelParams = [
    ];

    loader = {
      systemd-boot = {
        enable = lib.mkForce false;
        # editor = false;
        # configurationLimit = 10;
        # consoleMode = "max";
      };
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot";
      };
      timeout = 1;
    };

    tmp.useTmpfs = true;

    lanzaboote = {
      enable = true;
      pkiBundle = "/etc/secureboot";
    };
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
        device = "/dev/disk/by-partlabel/LINUX_ESP";
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
}
