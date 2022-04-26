{
  config,
  pkgs,
  inputs,
  lib,
  packages,
  ...
}: let
  env = {
    FLAKE = "/home/ayats/Documents/dotfiles";
    # NIX_AUTO_RUN = "1";
  };
in {
  viper = {
    defaultSpec = "kde";
  };

  environment.variables = env;
  environment.sessionVariables = env;
  home-manager.users.ayats = _: {
    home.sessionVariables = env;
  };

  environment.systemPackages = with pkgs; [
    # Keep
  ];

  environment.defaultPackages = [];

  boot = {
    initrd = {
      availableKernelModules = ["ahci" "nvme" "usbhid"];
      kernelModules = [
        "zfs"
      ];
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

    loader.systemd-boot = {
      enable = true;
      editor = true;
      configurationLimit = 10;
      consoleMode = "max";
    };

    loader.efi = {
      efiSysMountPoint = "/boot";
      canTouchEfiVariables = true;
    };

    # Build ARM
    binfmt.emulatedSystems = ["aarch64-linux"];
  };

  services.xserver = {
    layout = "us";
    videoDrivers = ["nvidia"];
    xkbOptions = "compose:rctrl";
    # displayManager.autoLogin.user = "ayats";
    libinput = {
      enable = true;
      mouse.accelProfile = "flat";
      mouse.accelSpeed = "0.0";
    };
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
    opengl.extraPackages = [
      pkgs.nvidia-vaapi-driver
    ];
    bluetooth = {
      enable = true;
    };
  };

  ### ZFS

  services.zfs = {
    autoScrub = {
      enable = true;
      pools = ["zroot"];
      interval = "weekly";
    };
  };

  virtualisation.docker.storageDriver = "zfs";

  swapDevices = [{device = "/dev/disk/by-label/LINUXSWAP";}];

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
      device = "zroot/system/nix";
      fsType = "zfs";
    };
    "/secrets" = {
      device = "zroot/secrets";
      fsType = "zfs";
      neededForBoot = true;
    };
    # "/home" = {
    #   device = "zroot/data/home";
    #   fsType = "zfs";
    #   neededForBoot = true;
    # };
    "/boot" = {
      device = "/dev/disk/by-label/LINUXESP";
      fsType = "vfat";
      options = [
        "x-systemd.automount"
        "x-systemd.mount-timeout=15min"
      ];
    };
    "/var/log" = {
      device = "zroot/system/log";
      fsType = "zfs";
      neededForBoot = true;
    };
    "/var/lib/tailscale" = {
      device = "zroot/system/tailscale";
      fsType = "zfs";
    };
    "/var/lib/systemd" = {
      device = "zroot/system/systemd";
      fsType = "zfs";
    };
    "/var/lib/libvirt" = {
      device = "zroot/system/libvirt";
      fsType = "zfs";
    };
    "/var/lib/libvirt/clean" = {
      device = "zroot/system/libvirt/clean";
      fsType = "zfs";
    };
    "/var/lib/docker" = {
      device = "zroot/system/docker";
      fsType = "zfs";
    };
    "/home/ayats/Music" = {
      device = "zroot/ayats/music";
      fsType = "zfs";
      options = ["x-gvfs-hide"];
    };
    "/home/ayats/Downloads" = {
      device = "zroot/ayats/downloads";
      fsType = "zfs";
      options = ["x-gvfs-hide"];
    };
    "/home/ayats/Pictures" = {
      device = "zroot/ayats/pictures";
      fsType = "zfs";
      options = ["x-gvfs-hide"];
    };
    "/home/ayats/Games" = {
      device = "zroot/ayats/games";
      fsType = "zfs";
      options = ["x-gvfs-hide"];
    };
    "/home/ayats/Videos" = {
      device = "zroot/ayats/videos";
      fsType = "zfs";
      options = ["x-gvfs-hide"];
    };
    "/home/ayats/Documents" = {
      device = "zroot/ayats/documents";
      fsType = "zfs";
      options = ["x-gvfs-hide"];
    };
    "/home/ayats" = {
      device = "zroot/ayats/home";
      fsType = "zfs";
      options = ["x-gvfs-hide"];
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
        "zroot/ayats/home"
        "zroot/ayats/documents"
        "zroot/ayats/music"
        "zroot/ayats/pictures"
        "zroot/ayats/videos"
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

  ### Secrets

  systemd.tmpfiles.rules = let
    inherit (config.users.users.ayats) group name home;
  in [
    "d /root/.ssh 0700 root root - -"
    "d /home/ayats/.ssh 0700 ayats users - -"
    #
    "L+ /etc/ssh/ssh_host_ed25519_key - - - - /secrets/ssh_host/ssh_host_ed25519_key"
    "L+ /etc/ssh/ssh_host_ed25519_key.pub - - - - /secrets/ssh_host/ssh_host_ed25519_key.pub"
    "L+ /etc/ssh/ssh_host_rsa_key - - - - /secrets/ssh_host/ssh_host_rsa_key"
    "L+ /etc/ssh/ssh_host_rsa_key.pub - - - - /secrets/ssh_host/ssh_host_rsa_key.pub"
    "z /home/ayats 700 ayats users - -"
  ];
  systemd.services.bind-ssh = {
    serviceConfig.Type = "forking";
    script = ''
      ${pkgs.bindfs}/bin/bindfs /secrets/ssh /root/.ssh
      ${pkgs.bindfs}/bin/bindfs --map=0/1000:@0/@100 /secrets/ssh /home/ayats/.ssh
    '';
    wantedBy = ["multi-user.target"];
    after = ["systemd-tmpfiles-setup.service"];
  };

  users.users.ayats.passwordFile = "/secrets/password/ayats";

  nix.extraOptions = ''
    secret-key-files = /secrets/cache-priv-key.pem
  '';

  ### Network

  networking = {
    hostName = "gen6";
    hostId = "01017f00";
    networkmanager = {
      enable = true;
      dns = "default";
    };
  };

  services.tailscale.enable = true;
  services.openssh = {
    enable = true;
    openFirewall = true;
    listenAddresses = [
      {
        addr = "100.113.242.22";
        port = 22;
      }
      {
        addr = "127.0.0.1";
        port = 22;
      }
    ];
  };
  networking.firewall.interfaces.tailscale0.allowedTCPPorts = [22];
  systemd.services.sshd.after = ["tailscaled.service"];

  ## Unsorted
  security.tpm2 = {
    enable = true;
    abrmd.enable = true;
  };
}
