{ config, lib, pkgs, modulesPath, ... }:

{
  programs = {
    xwayland.enable = true;
  };

  imports =
    [
      (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot = {
    initrd = {
      availableKernelModules = [ "ahci" "nvme" "usbhid" ];
      kernelModules = [ ];
      supportedFilesystems = [ "zfs" ];
      # Rollback ZFS on root
      postDeviceCommands = lib.mkAfter ''
        zfs rollback -r zroot/gen6/nixos@empty
      '';
    };

    kernelPackages = pkgs.linuxKernel.packages.linux_xanmod;
    kernelModules = [ "kvm-intel" ];
    kernelParams = [ ];
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
        gfxmodeEfi = "2560x1440";
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

    tmpOnTmpfs = true;
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
    hostId = "01017f00";
  };


  environment.systemPackages = with pkgs; [
    vulkan-tools
    libva-utils
  ];

  services = {
    xserver = {
      layout = "us";
      videoDrivers = [ "nvidia" ];
      xkbOptions = "compose:rctrl";
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
      settings = {
        "zroot/data/home" = {
          "use_template" = "normal";
        };
        "zroot/data/games" = {
          "use_template" = "slow";
        };
        "zroot/data/wine" = {
          "use_template" = "slow";
        };
        "zroot/data/steam" = {
          "use_template" = "slow";
        };
      };
    };

    zfs = {
      autoScrub = {
        enable = true;
        pools = [ "zroot" ];
        interval = "weekly";
      };
    };
  };

  virtualisation.docker = {
    storageDriver = "zfs";
    enableNvidia = true;
  };

  fileSystems."/" =
    {
      device = "zroot/gen6/nixos";
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
      neededForBoot = true;
    };

  fileSystems."/home" =
    {
      device = "zroot/data/home";
      fsType = "zfs";
      neededForBoot = true;
    };

  fileSystems."/boot" =
    {
      device = "/dev/disk/by-label/LINUXESP";
      fsType = "vfat";
    };

  swapDevices =
    [{ device = "/dev/disk/by-label/LINUXSWAP"; }];

  powerManagement.cpuFreqGovernor = "powersave";
  # https://discourse.nixos.org/t/nvidia-users-testers-requested-sway-on-nvidia-steam-on-wayland/15264/32

  hardware = {
    cpu.intel.updateMicrocode = true;
    # video.hidpi.enable = true;
    nvidia.modesetting.enable = true;
    logitech.wireless.enable = true;
    opengl.enable = true;
    opengl.driSupport = true;
    opengl.driSupport32Bit = true;
    pulseaudio.support32Bit = true;
    opengl.extraPackages = with pkgs; [
      vaapiVdpau
      libvdpau-va-gl
      libva
    ];
  };

  environment.etc."gbm/nvidia-drm_gbm.so".source = "${config.hardware.nvidia.package}/lib/libnvidia-allocator.so";
  environment.etc."egl/egl_external_platform.d".source = "/run/opengl-driver/share/egl/egl_external_platform.d/";

}
