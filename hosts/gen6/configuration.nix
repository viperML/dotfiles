{
  config,
  pkgs,
  inputs,
  lib,
  packages,
  ...
}: let
  prefix = "/run/current/system/sw/bin";
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
        emergencyAccess = false;
      };
    };
    tmpOnTmpfs = true;
    kernelPackages = config.boot.zfs.package.latestCompatibleLinuxPackages;
    kernelModules = ["kvm-intel"];
    # https://github.com/NixOS/nixpkgs/pull/171680
    kernelParams = ["nohibernate"];
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
    logitech = {
      wireless.enable = true;
      wireless.enableGraphical = true;
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
    "/var/lib/docker" = {
      device = "tank/system/docker";
      fsType = "zfs";
    };
    ###
    "/home/ayats" = {
      device = "tank/ayats/home";
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

  ### Secrets

  /*
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
   */

  users.users.ayats.password = "1234";

  # nix.extraOptions = ''
  #   secret-key-files = /secrets/cache-priv-key.pem
  # '';

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

  fonts.fontconfig.cache32Bit = true;

  services.fwupd = {
    enable = true;
  };
}
