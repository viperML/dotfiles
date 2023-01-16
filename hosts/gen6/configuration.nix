{
  config,
  pkgs,
  self,
  packages,
  flakePath,
  ...
}: {
  viper.env = {
    FLAKE = flakePath;
    EDITOR = "nvim";
    # SHELL = "fish";
    VAULT_ADDR = "http://kalypso:8200";
    NOMAD_ADDR = "http://chandra:4646";
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
    kernelPackages = config.boot.zfs.package.latestCompatibleLinuxPackages;

    # kernelPackages = let
    #   compatible = config.boot.zfs.package.latestCompatibleLinuxPackages;
    #   target = pkgs.linuxPackages_xanmod;
    # in
    #   if lib.versionAtLeast compatible.kernel.version target.kernel.version
    #   then target
    #   else throw "=> gen6: selected kernel is not compatible with ZFS";

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
        "wasm32-wasi"
      ];
    };

    kernel.sysctl = {
      "vm.swappiness" = 10;
    };
  };

  # environment.sessionVariables.XKB_DEFAULT_LAYOUT = "es,en";

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

  fileSystems = let
    mkMount = dataset: {
      device = dataset;
      fsType = "zfs";
      options = [
        "x-systemd.automount"
      ];
    };
  in {
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
    "/var/lib/systemd" = {
      device = "bigz/nixos/systemd";
      fsType = "zfs";
    };
    "/var/lib/tailscale" = mkMount "bigz/nixos/tailscale";
    "/var/lib/docker" = mkMount "bigz/nixos/docker";
    ###
    "/home/ayats/.config" = mkMount "bigz/ayats/dot-config";
    "/home/ayats/.local/share" = mkMount "bigz/ayats/dot-local-share";
    "/home/ayats/.cache" = mkMount "bigz/ayats/dot-cache";
    "/home/ayats/.ssh" = mkMount "bigz/ayats/dot-ssh";
    "/home/ayats/Documents" = mkMount "bigz/ayats/documents";
    "/home/ayats/Pictures" = mkMount "bigz/ayats/pictures";
    "/home/ayats/Music" = mkMount "bigz/ayats/music";
    "/home/ayats/Videos" = mkMount "bigz/ayats/videos";
    "/home/ayats/Downloads" = mkMount "bigz/ayats/downloads";
    "/home/ayats/Desktop" = mkMount "bigz/ayats/desktop";
  };

  swapDevices = [
    {
      label = "LINUXSWAP";
    }
  ];

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
    timerConfig = {
      OnCalendar = "monthly";
      Persistent = true;
    };
    wantedBy = ["timers.target"];
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

  services.openssh = {
    enable = true;
    openFirewall = false;
    hostKeys = [];
    extraConfig = ''
      TrustedUserCAKeys /var/lib/secrets/certs/ssh_user_key.pub
      HostKey /var/lib/secrets/certs/ssh_host_ecdsa_key
      HostCertificate /var/lib/secrets/certs/ssh_host_ecdsa_key-cert.pub
      AuthorizedPrincipalsFile /var/lib/secrets/principals/%u
    '';
  };

  systemd.services."step-renew" = {
    description = "Renew SSH certificates with step-ca and SSHPOP";
    path = [pkgs.step-cli];
    serviceConfig = {
      ExecStart =
        (pkgs.stdenvNoCC.mkDerivation {
          name = "step-renew-exec-start";
          dontUnpack = true;
          installPhase = "install -Dm555 ${self}/bin/renew_cert.sh $out";
        })
        .outPath;
    };
  };
  systemd.timers."step-renew" = {
    timerConfig = {
      OnCalendar = "daily";
      Persistent = true;
    };
    wantedBy = ["timers.target"];
  };

  services.tailscale.enable = true;
  networking.firewall.interfaces.tailscale0.allowedTCPPorts = [22];
  networking.firewall.interfaces.tailscale0.allowedTCPPortRanges = [
    {
      from = 8000;
      to = 8999;
    }
  ];

  services.fwupd = {
    enable = true;
  };

  programs.gamemode.enable = true;
  programs.steam.enable = true;
  fonts.fontconfig.cache32Bit = true;

  console = {
    font = "ter-v20n";
    packages = [pkgs.terminus_font];
    useXkbConfig = true;
    earlySetup = false;
  };

  # https://flokli.de/posts/2022-11-18-nsncd/
  services.nscd.enableNsncd = true;
}
