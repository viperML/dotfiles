{
  config,
  pkgs,
  inputs,
  lib,
  packages,
  ...
}: let
  prefix = "/run/current-system/sw/bin";
  env = {
    FLAKE = "/home/ayats/Documents/dotfiles";
    EDITOR = "${prefix}/nvim";
    SHELL = "${prefix}/fish";
  };
in {
  environment.variables = env;
  environment.sessionVariables = env;
  home-manager.users.ayats = _: {
    home.sessionVariables = env;
  };

  environment.systemPackages = with pkgs; [
    libva-utils
    pv
    packages.self.neovim
    packages.self.vshell
  ];

  environment.defaultPackages = [];

  boot = {
    initrd = {
      availableKernelModules = [
        "xhci_pci"
        "ahci"
        "nvme"
        "usb_storage"
        "usbhid"
        "sd_mod"
        "tpm"
      ];
      kernelModules = [
        "zfs"
        "kvm-intel"
      ];
      supportedFilesystems = ["zfs"];
      luks.devices."LUKSROOT" = {
        device = "/dev/disk/by-label/LUKSCONTAINER";
        crypttabExtraOpts = [
          "tpm2-device=auto"
        ];
      };
      systemd = {
        enable = true;
        emergencyAccess = true;
      };
    };
    tmpOnTmpfs = true;
    kernelPackages = let
      compatible = config.boot.zfs.package.latestCompatibleLinuxPackages;
      target = pkgs.linuxPackages_xanmod_latest;
    in
      if lib.versionAtLeast compatible.kernel.version target.kernel.version
      then target
      else
        builtins.trace
        "The kernel ${target.kernel.name} is not compatible with ZFS, using the default"
        compatible;
    kernelModules = ["kvm-intel"];
    kernelParams = [
      # https://github.com/NixOS/nixpkgs/pull/171680
      "nohibernate"
    ];
    supportedFilesystems = ["zfs"];

    zfs = {
      enableUnstable = true;
      forceImportAll = false;
      forceImportRoot = false;
    };

    loader.systemd-boot = {
      enable = true;
      editor = false;
      configurationLimit = 10;
      consoleMode = "max";
      netbootxyz.enable = true;
    };

    loader.efi = {
      efiSysMountPoint = "/efi";
      canTouchEfiVariables = true;
    };

    binfmt = {
      emulatedSystems = ["aarch64-linux"];
    };

    kernel.sysctl = {
      "vm.swappiness" = 10;
    };
  };

  services.xserver = {
    layout = "us";
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
    bluetooth = {
      enable = true;
    };
  };

  ### ZFS

  services.zfs = {
    autoScrub = {
      enable = true;
      pools = ["tank"];
      interval = "weekly";
    };
  };

  services.smartd = {
    enable = true;
    notifications.x11.enable = true;
  };

  virtualisation.docker.storageDriver = "zfs";

  swapDevices = [{device = "/dev/tank/swap";}];

  fileSystems = {
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
      device = "tank/system/nix";
      fsType = "zfs";
    };
    "/efi" = {
      device = "/dev/disk/by-label/LINUXESP";
      fsType = "vfat";
      options = [
        "x-systemd.automount"
        "x-systemd.mount-timeout=15min"
      ];
    };
    ###
    "/var/lib/secrets" = {
      device = "tank/system/secrets";
      fsType = "zfs";
      neededForBoot = true;
    };
    "/var/log" = {
      device = "tank/system/log";
      fsType = "zfs";
      neededForBoot = true;
    };
    "/var/lib/tailscale" = {
      device = "tank/system/tailscale";
      fsType = "zfs";
    };
    "/var/lib/systemd" = {
      device = "tank/system/sd";
      fsType = "zfs";
    };
    "/var/lib/libvirt" = {
      device = "tank/system/libvirt";
      fsType = "zfs";
    };
    "/var/lib/libvirt/images-clean" = {
      device = "tank/system/libvirt-clean";
      fsType = "zfs";
    };
    # "/var/lib/docker" = {
    #   device = "tank/system/docker";
    #   fsType = "zfs";
    # };
    # "/var/lib/containerd/io.containerd.snapshotter.v1.zfs" = {
    #   device = "tank/system/containerd";
    #   fsType = "zfs";
    # };
    ###
    "/home/ayats" = {
      device = "tank/ayats/home";
      fsType = "zfs";
      options = ["x-gvfs-hide"];
    };
    "/windows" = {
      device = "/dev/nvme1n1p3";
      fsType = "ntfs";
      options = [
        "noatime"
        "ro"
        "noauto"
      ];
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
        "monthly" = 1;
        "yearly" = 0;
        "autosnap" = true;
        "autoprune" = true;
      };
    };
    datasets = let
      slow-datasets = [
        "tank/system/secrets"
      ];
      normal-datasets = [
        "tank/ayats/home"
        "tank/ayats/documents"
        "tank/ayats/music"
        "tank/ayats/pictures"
        "tank/ayats/videos"
        "tank/system/secrets"
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

  systemd.tmpfiles.rules = [
    "d /windows 744 root root - -"
  ];

  users.users.ayats.password = "1234";

  nix = {
    daemonCPUSchedPolicy = "idle";
    daemonIOSchedClass = "idle";
  };

  ### Network

  networking = {
    hostName = "gen6";
    hostId = builtins.substring 0 8 (builtins.hashString "md5" config.networking.hostName);
    networkmanager = {
      enable = true;
      dns = "default";
    };
    # Strict reverse path filtering breaks Tailscale exit node use and some subnet routing setups.
    firewall.checkReversePath = "loose";
  };

  # AuthorizedPrincipalsFile /secrets/ssh-certs/principals
  services.openssh = {
    enable = true;
    # logLevel = "DEBUG1";
    openFirewall = false;
    hostKeys = [];
    extraConfig = ''
      TrustedUserCAKeys /var/lib/secrets/certs/ssh_user_key.pub
      HostKey /var/lib/secrets/certs/ssh_host_ecdsa_key
      HostCertificate /var/lib/secrets/certs/ssh_host_ecdsa_key-cert.pub
      AuthorizedPrincipalsFile /var/lib/secrets/certs/principals/%u
    '';
  };

  services.tailscale.enable = true;
  networking.firewall.interfaces.tailscale0.allowedTCPPorts = [22];
  networking.firewall.interfaces.tailscale0.allowedTCPPortRanges = [
    {
      from = 8000;
      to = 8999;
    }
  ];

  security.tpm2 = {
    enable = true;
    abrmd.enable = true;
  };

  services.fwupd = {
    enable = true;
  };

  programs.gamemode.enable = true;
  programs.steam.enable = true;
  fonts.fontconfig.cache32Bit = true;

  # virtualisation.containerd = {
  #   enable = true;
  # };

  console = {
    font = "ter-v20n";
    packages = [pkgs.terminus_font];
  };
}
