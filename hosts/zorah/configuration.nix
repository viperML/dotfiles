{
  lib,
  pkgs,
  config,
  # self',
  ...
}:
let
  luksDevice = "luksroot";
in
{
  environment.systemPackages = with pkgs; [
    # global dev
    openconnect
    ltex-ls-plus
    neocmakelsp
    sshfs
    unzip
    gitlab-ci-local
    dockerfile-language-server-nodejs
    distrobox

    # GUI
    mattermost-desktop
    slack
    drawio
    thunderbird-latest
    # self'.packages.emacs
    zoom-us
    ungoogled-chromium
    # gnomeExtensions.cloudflare-warp-toggle
    zen-browser
  ];

  environment.sessionVariables = rec {
    D = "/var/home/ayats/Documents/dotfiles";
    NH_FILE = "${D}/hosts/zorah";
  };

  networking = {
    hostName = "zorah";
    networkmanager = {
      enable = true;
      dns = "systemd-resolved";
    };
    nftables.enable = true;
    firewall.enable = false;
  };

  services.resolved = {
    enable = true;
  };

  security.sudo.wheelNeedsPassword = false;

  system.stateVersion = "23.11";

  # powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";

  hardware = {
    cpu.intel.updateMicrocode = true;
    # enableAllFirmware = true;
    enableRedistributableFirmware = true;
    bluetooth.enable = true;
    graphics = {
      enable = true;
      extraPackages = [ pkgs.intel-media-driver ];
    };
  };

  services.fwupd.enable = true;

  # services.cpupower-gui.enable = true;
  # services.flatpak.enable = true;

  services.flatpak = {
    enable = true;
  };

  services.printing = {
    enable = true;
  };

  boot = {
    lanzaboote = {
      enable = true;
      pkiBundle = "/var/lib/secrets/secureboot";
    };

    kernelPackages = pkgs.linuxPackages_latest;

    initrd = {
      systemd.enable = true;
      availableKernelModules = [
        "xhci_pci"
        "thunderbolt"
        "vmd"
        "nvme"
        "usb_storage"
        "sd_mod"
        "rtsx_pci_sdmmc"
      ];

      luks = {
        devices.${luksDevice} = {
          device = "/dev/disk/by-partlabel/LINUX_LUKS";
        };
      };
    };

    kernel.sysctl = {
      # "vm.swappiness" = 100;
      "kernel.split_lock_mitigate" = "0";
    };

    kernelParams = [ ];

    kernelModules = [ "kvm-intel" ];

    loader = {
      systemd-boot.enable = lib.mkForce false;
      grub.enable = lib.mkForce false;
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot";
      };
      # timeout = 1;
    };

    tmp = {
      useTmpfs = false;
    };
  };

  fileSystems = {
    "/" = {
      device = "/dev/mapper/${luksDevice}";
      fsType = "xfs";
      options = [ "noatime" ];
    };

    ${config.boot.loader.efi.efiSysMountPoint} = {
      device = "/dev/disk/by-partlabel/ESP";
      fsType = "vfat";
      options = [
        "x-systemd.automount"
        "x-systemd.mount-timeout=15min"
        "umask=077"
      ];
    };
  };
  # specialisation."nvidia" = {
  #   configuration = {
  #     environment.etc."specialisation".text = "nvidia";
  #     imports = [./nvidia.nix];
  #   };
  # };

  # systemd.services."openconnect-inria" = {
  #   # enable = false;
  #   # after = ["NetworkManager.service"];
  #   path = [ pkgs.openconnect ];
  #   script = ''
  #     exec openconnect vpn.inria.fr -u fayatsll --passwd-on-stdin < /var/lib/secrets/vpn-pw
  #   '';
  #   serviceConfig = {
  #     Restart = "always";
  #   };
  #   unitConfig = {
  #     StartLimitIntervalSec = 10;
  #     StartLimitBurst = 30;
  #   };
  # };

  programs.singularity = {
    enable = true;
    enableSuid = true;
  };

  programs.msmtp = {
    enable = true;
  };

  services.xserver.wacom.enable = true;

  services.cloudflare-warp.enable = true;

  services.hardware.bolt.enable = true;

  users.users.ayats.maid = {
    systemd.tmpfiles.dynamicRules = [
      "L /tmp/cursor-settings - - - - {{home}}/Documents/dotfiles/misc/cursor-settings"
    ];
  };
}
