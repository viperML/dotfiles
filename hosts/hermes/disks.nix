{config, ...}: let
  efiSysMountPoint = "/efi";
  efiSize = "500M";
  mountOptions = ["noatime" "compress=lzo"];
in {
  boot.loader = {
    systemd-boot = {
      enable = true;
      consoleMode = "max";
      editor = false;
      configurationLimit = 10;
    };
    efi = {
      canTouchEfiVariables = true;
      inherit efiSysMountPoint;
    };
    timeout = 1;
  };

  boot.tmp.useTmpfs = true;

  disko.devices.nodev."/" = {
    fsType = "tmpfs";
    mountOptions = [
      "size=2G"
      "defaults"
      "mode=0755"
    ];
  };

  disko.devices.disk."LINUX" = {
    device = "/dev/nvme1n1";
    type = "disk";
    content = {
      type = "gpt";
      partitions = {
        esp = {
          label = "LINUX_ESP";
          size = efiSize;
          content = {
            type = "filesystem";
            format = "vfat";
            mountpoint = efiSysMountPoint;
            mountOptions = [
              "x-systemd.automount"
              "x-systemd.mount-timeout=15min"
              "umask=077"
            ];
          };
        };

        swap = {
          label = "LINUX_SWAP";
          size = "8G";
          content = {
            type = "swap";
            resumeDevice = true;
          };
        };

        data = {
          label = "LINUX_ROOT";
          size = "100%";
          content = {
            type = "btrfs";
            extraArgs = ["-f"];
            subvolumes = let
              mkBtrfs = mountpoint: {
                inherit mountpoint;
                mountOptions =
                  mountOptions
                  ++ [
                    "x-systemd.automount"
                  ];
              };
            in {
              "/@nixos/@nix" = {
                mountpoint = "/nix";
                inherit mountOptions;
              };
              "/@secrets" = mkBtrfs "/var/lib/secrets";
              "/@home" = mkBtrfs "/home";
              #
              "/@nixos/@log" = mkBtrfs "/var/log";
              "/@nixos/@nm" = mkBtrfs "/var/lib/NetworkManager";
              "/@nixos/@systemd" = mkBtrfs "/var/lib/systemd";
              "/@nixos/@tailscale" = mkBtrfs "/var/lib/tailscale";
            };
          };
        };
      };
    };
  };

  fileSystems = {
    "/.btrfs" = {
      device = config.disko.devices.disk."LINUX".content.partitions.data.device;
      fsType = "btrfs";
      options = mountOptions ++ ["x-systemd.automount"];
    };
    "/@nixos" = {
      device = config.disko.devices.disk."LINUX".content.partitions.data.device;
      fsType = "btrfs";
      options = mountOptions ++ ["subvol=/@nixos" "x-systemd.automount"];
    };
    "/var/lib/secrets" = {
      neededForBoot = true;
    };
  };
}
