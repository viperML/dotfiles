{
  config,
  lib,
  pkgs,
  ...
}: {
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
    };

    binfmt.emulatedSystems = [
      "aarch64-linux"
      "wasm32-wasi"
    ];

    kernel.sysctl = {
      "vm.swappiness" = 10;
    };

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
    btrfsOptions = [
      "noatime"
      "compress=lzo"
    ];
    btrfsDevice = "/dev/disk/by-partlabel/LINUX_ROOT";
    mkBtrfs = subvol: {
      device = btrfsDevice;
      fsType = "btrfs";
      options = btrfsOptions ++ ["subvol=${subvol}"];
    };
  in {
    "/" = {
      device = "none";
      fsType = "tmpfs";
      options = [
        "size=2G"
        "mode=0755"
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

    "/nix" = mkBtrfs "/@nixos/@nix";
    "/home" = mkBtrfs "/@home";
    "/var/lib/NetworkManager" = mkBtrfs "/@nixos/@nm";
    "/var/lib/secrets" = lib.mkMerge [
      (mkBtrfs "/@secrets")
      {
        neededForBoot = true;
      }
    ];
    "/var/lib/systemd" = mkBtrfs "/@nixos/@systemd";
    "/var/lib/tailscale" = mkBtrfs "/@nixos/@tailscale";
    "/var/log" = lib.mkMerge [
      (mkBtrfs "/@nixos/@log")
      {
        neededForBoot = true;
      }
    ];
    "/.btrfs" = mkBtrfs "/";
    "/.btrfs/@nixos" = mkBtrfs "/@nixos";
  };

  swapDevices = [
    {
      device = "/dev/disk/by-partlabel/LINUX_SWAP";
    }
  ];
}
