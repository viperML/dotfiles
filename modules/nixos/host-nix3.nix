# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }:
{

  imports =
    [
      (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot = {
    initrd = {
      availableKernelModules = [ "ahci" "nvme" "usbhid" ];
      kernelModules = [ ];
      supportedFilesystems = [ "zfs" ];
      # postDeviceCommands = lib.mkAfter ''
      #   zfs rollback -r zroot/gen6/nixos@empty
      # '';
    };

    kernelPackages = pkgs.zfs.latestCompatibleLinuxPackages;
    kernelModules = [ "kvm-intel" ];
    extraModulePackages = [ ];
    supportedFilesystems = [ "zfs" ];

    zfs = {
      enableUnstable = true;
      forceImportAll = false;
      forceImportRoot = false;
    };

    loader = {

      grub = {
        device = "nodev";
        enable = true;
        efiSupport = true;
        zfsSupport = true;
        # gfxmodeEfi = "2560x1440";
        configurationLimit = 20;
        extraFiles = {
          "netboot.xyz.efi" = "${pkgs.netboot-xyz-images}/netboot.xyz.efi";
        };
        extraEntries = ''
          ### Start netboot.xyz
          menuentry "netboot.xyz" {
              chainloader /netboot.xyz.efi
          }
          ### End netboot.xyz
        '';
      };

      efi = {
        efiSysMountPoint = "/boot";
        canTouchEfiVariables = true;
      };
    };
  };

  systemd = {
    services.sanoid = {
      serviceConfig = {
        DynamicUser = lib.mkForce false;
        Group = lib.mkForce "root";
        User = lib.mkForce "root";
      };
    };
  };

  networking = {
    hostName = "nix3";
    hostId = builtins.substring 0 8 (builtins.hashString "md5" config.networking.hostName);
    networkmanager.enable = true;
  };


  environment.systemPackages = with pkgs; [
    # libsForQt5.kdenlive
    # ffmpeg
  ];

  services = {
    xserver = {
      layout = "es";
      videoDrivers = [ "radeon" "amdgpu" ];
    };

    sanoid = {
      enable = true;
      templates = {
        "normal" = {
          "frequently" = 0;
          "hourly" = 1;
          "daily" = 1;
          "monthly" = 4;
          "yearly" = 0;
          "autosnap" = true;
          "autoprune" = true;
        };
        "slow" = {
          "frequently" = 0;
          "hourly" = 0;
          "daily" = 0;
          "monthly" = 4;
          "yearly" = 0;
          "autosnap" = true;
          "autoprune" = true;
        };
      };
      # TODO
      # settings = {
      #   "zroot/data/home" = {
      #     "use_template" = "normal";
      #   };
      #   "zroot/data/games" = {
      #     "use_template" = "slow";
      #   };
      #   "zroot/data/wine" = {
      #     "use_template" = "slow";
      #   };
      #   "zroot/data/steam" = {
      #     "use_template" = "slow";
      #   };
      # };
    };

    zfs = {
      autoScrub = {
        enable = true;
        pools = [ "zroot" ];
        interval = "monthly";
      };
    };
  };

  virtualisation.docker = {
    storageDriver = "zfs";
    # enableNvidia = true;
  };

  fileSystems."/" =
    {
      device = "zroot/${config.networking.hostName}/nixos";
      fsType = "zfs";
    };

  fileSystems."/nix" =
    {
      device = "zroot/nix";
      fsType = "zfs";
    };

  fileSystems."/secrets" =
    {
      device = "zroot/secrets";
      fsType = "zfs";
    };

  fileSystems."/boot" =
    {
      device = "/dev/disk/by-label/LINUXESP";
      fsType = "vfat";
    };

  swapDevices =
    [{ device = "/dev/disk/by-label/LINUXSWAP"; }];

  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";

  hardware = {
    cpu.amd.updateMicrocode = true;
    video.hidpi.enable = lib.mkDefault true;
  };
}
