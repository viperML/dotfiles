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

  swapDevices = [
    {
      device = swapfile;
    }
  ];

  security.tpm2 = {
    enable = true;
  };

  systemd.services.create-swapfile = {
    serviceConfig.Type = "oneshot";
    wantedBy = [ "swapfile.swap" ];
    path = with pkgs; [
      coreutils
      e2fsprogs
    ];
    script = ''
      set -x
      if [[ ! -f ${swapfile} ]]; then
        dd if=/dev/zero of=${swapfile} bs=1M count=8k status=progress
        chmod 0600 ${swapfile}
        mkswap -U clear ${swapfile}
      fi
    '';
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
