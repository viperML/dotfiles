{
  config,
  pkgs,
  inputs,
  lib,
  packages,
  ...
}: {
  viper.env = {
    # FIXME move to module.args
    FLAKE = "/home/ayats/Documents/dotfiles";
    EDITOR = "/run/current-system/sw/bin/nvim";
    SHELL = "/run/current-system/sw/bin/fish";
    VAULT_ADDR = "http://kalypso:8200";
    NOMAD_ADDR = "http://sumati:4646";
  };

  environment.systemPackages = [
    packages.self.fish
  ];

  boot = {
    initrd = {
      availableKernelModules = [
        "xhci_pci"
        "ahci"
        "nvme"
        "usbhid"
        # "sd_mod"
        # "usb_storage"
        # "tpm"
      ];
      supportedFilesystems = [
        "zfs"
      ];
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
    kernelParams = [
    ];

    supportedFilesystems = [
      "zfs"
    ];

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

    loader.timeout = 1;

    binfmt = {
      emulatedSystems = [
        "aarch64-linux"
      ];
    };

    kernel.sysctl = {
      "vm.swappiness" = 10;
    };
  };

  services.xserver = {
    layout = "es";
    xkbOptions = "compose:rctrl";
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
      pools = ["bigz"];
      interval = "weekly";
    };
  };

  services.smartd = {
    enable = true;
    notifications.x11.enable = true;
  };

  virtualisation.docker.storageDriver = "zfs";

  # swapDevices = [{device = "/dev/tank/swap";}];

  fileSystems = {
    "/" = {
      fsType = "tmpfs";
      device = "none";
      options = [
        "defaults"
        "size=4G"
        "mode=0755"
      ];
    };
    "/nix" = {
      device = "bigz/nixos/nix";
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
      device = "bigz/nixos/secrets";
      fsType = "zfs";
      neededForBoot = true;
    };
    "/var/log" = {
      device = "bigz/nixos/log";
      fsType = "zfs";
      neededForBoot = true;
    };
    "/var/lib/tailscale" = {
      device = "bigz/nixos/tailscale";
      fsType = "zfs";
      options = [
        "x-systemd.automount"
      ];
    };
    "/var/lib/systemd" = {
      device = "bigz/nixos/systemd";
      fsType = "zfs";
    };
    ###
    "/home/ayats/.config" = {
      device = "bigz/ayats/dot-config";
      fsType = "zfs";
      options = [
        "x-systemd.automount"
      ];
    };
    "/home/ayats/.local/share" = {
      device = "bigz/ayats/dot-local-share";
      fsType = "zfs";
      options = [
        "x-systemd.automount"
      ];
    };
    "/home/ayats/.cache" = {
      device = "bigz/ayats/dot-cache";
      fsType = "zfs";
      options = [
        "x-systemd.automount"
      ];
    };
    "/home/ayats/.ssh" = {
      device = "bigz/ayats/dot-ssh";
      fsType = "zfs";
      options = [
        "x-systemd.automount"
      ];
    };
    "/home/ayats/Documents" = {
      device = "bigz/ayats/documents";
      fsType = "zfs";
      options = [
        "x-systemd.automount"
      ];
    };
    "/home/ayats/Pictures" = {
      device = "bigz/ayats/pictures";
      fsType = "zfs";
      options = [
        "x-systemd.automount"
      ];
    };
    "/home/ayats/Music" = {
      device = "bigz/ayats/music";
      fsType = "zfs";
      options = [
        "x-systemd.automount"
      ];
    };
    "/home/ayats/Videos" = {
      device = "bigz/ayats/videos";
      fsType = "zfs";
      options = [
        "x-systemd.automount"
      ];
    };
    "/home/ayats/Downloads" = {
      device = "bigz/ayats/downloads";
      fsType = "zfs";
      options = [
        "x-systemd.automount"
      ];
    };
    "/home/ayats/Desktop" = {
      device = "bigz/ayats/desktop";
      fsType = "zfs";
      options = [
        "x-systemd.automount"
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
      ];
      normal-datasets = [
        "bigz/ayats/documents"
        "bigz/ayats/dot-config"
        "bigz/ayats/dot-ssh"
        "bigz/ayats/downloads"
        "bigz/ayats/music"
        "bigz/ayats/pictures"
        "bigz/ayats/videos"
        "bigz/nixos/secrets"
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
    description = "Rollback dot-cache@clean";
    before = ["multi-user.target"];
    serviceConfig.Type = "oneshot";
    serviceConfig.ExecStart =
      (pkgs.writeShellScript "exec-start" ''
        ${pkgs.zfs}/bin/zfs rollback ${config.fileSystems."/home/ayats/.cache".device}@clean
        ${pkgs.systemd}/bin/systemd-tmpfiles --create
      '')
      .outPath;
  };
  systemd.timers."zfs-rollback-dot-cache" = {
    timerConfig.OnCalendar = "monthly";
    timerConfig.Persistent = true;
    wantedBy = ["timers.target"];
  };

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
    useXkbConfig = true;
    earlySetup = false;
  };
}
