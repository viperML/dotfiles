{
  config,
  pkgs,
  inputs,
  lib,
  packages,
  ...
}: {
  viper.env = {
    FLAKE = "/home/ayats/Documents/dotfiles";
    EDITOR = "/run/current-system/sw/bin/nvim";
    SHELL = "/run/current-system/sw/bin/fish";
    VAULT_ADDR = "http://kalypso:8200";
    NOMAD_ADDR = "http://sumati:4646";
  };

  environment.systemPackages = with pkgs; [
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
      target = pkgs.linuxPackages_xanmod;
    in
      if lib.versionAtLeast compatible.kernel.version target.kernel.version
      then target
      else throw "=> gen6: selected kernel is not compatible with ZFS";
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
    ${config.boot.loader.efi.efiSysMountPoint} = {
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
    ###
    "/home/ayats/.config" = {
      device = "tank/ayats/dot-config";
      fsType = "zfs";
    };
    "/home/ayats/.local" = {
      device = "tank/ayats/dot-local";
      fsType = "zfs";
    };
    "/home/ayats/.cache" = {
      device = "tank/ayats/dot-cache";
      fsType = "zfs";
    };
    "/home/ayats/.ssh" = {
      device = "tank/ayats/dot-ssh";
      fsType = "zfs";
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

  systemd.services."zfs-rollback-dot-cache" = {
    description = "Rollback tank/ayats/dot-cache@clean";
    before = ["multi-user.target"];
    serviceConfig.Type = "oneshot";
    serviceConfig.ExecStart =
      (pkgs.writeShellScript "exec-start" ''
        ${pkgs.zfs}/bin/zfs rollback tank/ayats/dot-cache@clean
        ${pkgs.systemd}/bin/systemd-tmpfiles --create
      '')
      .outPath;
  };
  systemd.timers."zfs-rollback-dot-cache" = {
    timerConfig.OnCalendar = "monthly";
    timerConfig.Persistent = true;
    wantedBy = ["timers.target"];
  };

  systemd.tmpfiles.rules = [
    "d /windows 744 root root - -"
  ];

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

  # security.tpm2 = {
  #   enable = true;
  #   abrmd.enable = true;
  # };

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
