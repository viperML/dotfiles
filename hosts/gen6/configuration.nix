{
  config,
  pkgs,
  inputs,
  lib,
  ...
}: let
  FLAKE = "/home/ayats/Documents/dotfiles";
in {
  environment.variables = {inherit FLAKE;};
  environment.sessionVariables = {inherit FLAKE;};

  environment.systemPackages = with pkgs; [
    # Keep
  ];

  boot = {
    initrd = {
      availableKernelModules = ["ahci" "nvme" "usbhid"];
      kernelModules = [];
      supportedFilesystems = ["zfs"];
      # Rollback ZFS on root
      # postDeviceCommands = lib.mkAfter ''
      #   zfs rollback -r zroot/gen6/nixos@empty
      # '';
    };
    tmpOnTmpfs = true;
    kernelPackages = pkgs.zfs.latestCompatibleLinuxPackages;
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
      default = "saved";
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
    displayManager.autoLogin.user = "ayats";
    libinput = {
      enable = true;
      mouse.accelProfile = "flat";
      mouse.accelSpeed = "0.0";
    };
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
        # keep
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
      (builtins.listToAttrs (
        builtins.map (dataset: {
          name = dataset;
          value.use_template = ["slow"];
        })
        slow-datasets
      ))
      // (builtins.listToAttrs (
        builtins.map (dataset: {
          name = dataset;
          value.use_template = ["normal"];
        })
        normal-datasets
      ));
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
    # "/" = {
    #   device = "zroot/gen6/nixos";
    #   fsType = "zfs";
    # };
    "/" = {
      fsType = "tmpfs";
      device = "none";
      options = [
        "defaults"
        "size=2G"
        "mode=755"
      ];
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
    "/var/lib/systemd" = {
      device = "zroot/data/systemd";
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

  swapDevices = [{device = "/dev/disk/by-label/LINUXSWAP";}];

  systemd.tmpfiles.rules = let
    inherit (config.users.users.mainUser) group name home;
  in [
    "z /secrets/ssh 0700 ${name} ${group} - -"
    "z /secrets/ssh/config 0600 ${name} ${group} - -"
    "z /secrets/ssh/id_ed25519 0600 ${name} ${group} - -"
    "z /secrets/ssh/id_ed25519.pub 0644 ${name} ${group} - -"
    "z /secrets/ssh/known_hosts 0600 ${name} ${group} - -"
    "d /root/.ssh 0700 root root - -"
    "L+ ${home}/.ssh - - - - /secrets/ssh"
    #
    "L+ /etc/ssh/ssh_host_ed25519_key - - - - /secrets/ssh_host/ssh_host_ed25519_key"
    "L+ /etc/ssh/ssh_host_ed25519_key.pub - - - - /secrets/ssh_host/ssh_host_ed25519_key.pub"
    "L+ /etc/ssh/ssh_host_rsa_key - - - - /secrets/ssh_host/ssh_host_rsa_key"
    "L+ /etc/ssh/ssh_host_rsa_key.pub - - - - /secrets/ssh_host/ssh_host_rsa_key.pub"
  ];
  systemd.services.bind-ssh = {
    serviceConfig.Type = "forking";
    script = ''
      ${pkgs.bindfs}/bin/bindfs --map=1000/0:@100/@0 -p ugo-x /secrets/ssh /root/.ssh
    '';
    wantedBy = ["multi-user.target"];
  };

  powerManagement.cpuFreqGovernor = "powersave";
  hardware = {
    cpu.intel.updateMicrocode = true;
    enableRedistributableFirmware = true;
    nvidia.modesetting.enable =
      config.services.xserver.displayManager.gdm.enable;
    nvidia.package = config.boot.kernelPackages.nvidiaPackages.beta;
    nvidia.powerManagement.enable = false;
    opengl.enable = true;
    opengl.driSupport = true;
    opengl.driSupport32Bit = true;
    pulseaudio.support32Bit = true;
    opengl.extraPackages = with pkgs; [
      mesa.drivers
    ];
  };

  networking.networkmanager = {
    enable = true;
    dns = "default";
  };
}
