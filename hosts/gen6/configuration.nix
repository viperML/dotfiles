{
  config,
  pkgs,
  inputs,
  lib,
  ...
}: {
  environment.systemPackages = with pkgs; [
    # HW
    vulkan-tools
    libva-utils

    # Base
    masterpdfeditor4
    onlyoffice-bin
    mpv
    (g-papirus-icon-theme.override {color = "palebrown";})
    qbittorrent
    android-tools
    tor-browser-bundle-bin

    # Misc
    ahoviewer
    krita-beta
    obs-studio
    obsidian
    # inkscape
  ];

  boot = {
    initrd = {
      availableKernelModules = ["ahci" "nvme" "usbhid"];
      kernelModules = [];
      supportedFilesystems = ["zfs"];
      # Rollback ZFS on root
      postDeviceCommands = lib.mkAfter ''
        zfs rollback -r zroot/gen6/nixos@empty
      '';
    };
    tmpOnTmpfs = true;
    kernelPackages = pkgs.linuxKernel.packages.linux_xanmod;
    kernelModules = ["kvm-intel"];
    kernelParams = [];
    supportedFilesystems = ["zfs"];

    zfs = {
      enableUnstable = true;
      forceImportAll = false;
      forceImportRoot = false;
    };

    loader.grub = {
      device = "nodev";
      enable = true;
      efiSupport = true;
      zfsSupport = true;
      gfxmodeEfi = "2560x1440";
      configurationLimit = 10;
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

    loader.efi = {
      efiSysMountPoint = "/boot";
      canTouchEfiVariables = true;
    };

    # Build ARM
    binfmt.emulatedSystems = ["aarch64-linux"];
  };

  networking = {
    hostName = "gen6";
    hostId = "01017f00";
  };

  services.xserver = {
    layout = "us";
    videoDrivers = ["nvidia"];
    xkbOptions = "compose:rctrl";
  };

  services.sanoid = {
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
    datasets = let
      slow-datasets = [
        "zroot/data/games"
        "zroot/data/steam"
      ];
      normal-datasets = [
        # "zroot/data/downloads"
        "zroot/data/documents"
        "zroot/data/music"
        "zroot/data/pictures"
        "zroot/data/videos"
        "zroot/secrets"
      ];
    in
      (
        builtins.listToAttrs (
          builtins.map (
            dataset: {
              name = dataset;
              value.use_template = ["slow"];
            }
          )
          slow-datasets
        )
      )
      // (
        builtins.listToAttrs (
          builtins.map (
            dataset: {
              name = dataset;
              value.use_template = ["normal"];
            }
          )
          normal-datasets
        )
      );
  };

  services.zfs = {
    autoScrub = {
      enable = true;
      pools = ["zroot"];
      interval = "weekly";
    };
  };

  virtualisation.docker = {
    storageDriver = "zfs";
    enableNvidia = true;
  };

  fileSystems = {
    "/" = {
      device = "zroot/gen6/nixos";
      fsType = "zfs";
    };
    "/nix" = {
      device = "zroot/nix";
      fsType = "zfs";
    };
    "/secrets" = {
      device = "zroot/secrets";
      fsType = "zfs";
      neededForBoot = true;
    };
    "/home" = {
      device = "zroot/data/home";
      fsType = "zfs";
      neededForBoot = true;
    };
    "/boot" = {
      device = "/dev/disk/by-label/LINUXESP";
      fsType = "vfat";
    };
    "/var/log" = {
      device = "zroot/data/log";
      fsType = "zfs";
      neededForBoot = true;
    };
    "/var/lib/tailscale" = {
      device = "zroot/data/tailscale";
      fsType = "zfs";
    };
    "/home/ayats/Music" = {
      device = "zroot/data/music";
      fsType = "zfs";
      options = ["x-gvfs-hide"];
    };
    "/home/ayats/Downloads" = {
      device = "zroot/data/downloads";
      fsType = "zfs";
      options = ["x-gvfs-hide"];
    };
    "/home/ayats/Pictures" = {
      device = "zroot/data/pictures";
      fsType = "zfs";
      options = ["x-gvfs-hide"];
    };
    "/home/ayats/Games" = {
      device = "zroot/data/games";
      fsType = "zfs";
      options = ["x-gvfs-hide"];
    };
    "/home/ayats/Videos" = {
      device = "zroot/data/videos";
      fsType = "zfs";
      options = ["x-gvfs-hide"];
    };
    "/home/ayats/Documents" = {
      device = "zroot/data/documents";
      fsType = "zfs";
      options = ["x-gvfs-hide"];
    };
  };

  systemd.tmpfiles.rules = [
    "L+ /etc/ssh/ssh_host_ed25519_key - - - - /secrets/ssh_host/ssh_host_ed25519_key"
    "L+ /etc/ssh/ssh_host_ed25519_key.pub - - - - /secrets/ssh_host/ssh_host_ed25519_key.pub"
    "L+ /etc/ssh/ssh_host_rsa_key - - - - /secrets/ssh_host/ssh_host_rsa_key"
    "L+ /etc/ssh/ssh_host_rsa_key.pub - - - - /secrets/ssh_host/ssh_host_rsa_key.pub"
  ];

  swapDevices = [{device = "/dev/disk/by-label/LINUXSWAP";}];

  powerManagement.cpuFreqGovernor = "powersave";

  hardware = {
    cpu.intel.updateMicrocode = true;
    enableRedistributableFirmware = true;
    nvidia.modesetting.enable =
      config.services.xserver.displayManager.gdm.enable;
    nvidia.package = config.boot.kernelPackages.nvidiaPackages.beta;
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

  programs = {
    xwayland.enable = true;
  };

  security.tpm2 = {
    enable = true;
    abrmd.enable = true;
  };

  networking.networkmanager = {
    enable = true;
    dns = "default";
  };
}
