{
  lib,
  pkgs,
  config,
  self',
  ...
}: let
  luksDevice = "luksroot";
in {
  environment.sessionVariables.FLAKE = "/var/home/ayats/Documents/dotfiles";

  networking = {
    hostName = "hermes";
    networkmanager = {
      enable = true;
      dns = "systemd-resolved";
    };
    nftables.enable = true;
  };

  services.resolved = {enable = true;};

  users.mutableUsers = lib.mkForce true;

  security.sudo.wheelNeedsPassword = false;

  system.stateVersion = "23.11";

  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";

  hardware = {
    cpu.intel.updateMicrocode = true;
    enableRedistributableFirmware = true;
    bluetooth.enable = true;
    graphics = {
      enable = true;
      extraPackages = with pkgs.rocmPackages; [clr clr.icd];
    };
  };

  services.fwupd.enable = true;

  security.pam.services = {
    login.u2fAuth = true;
    sudo.u2fAuth = true;
  };

  services.thermald.enable = true;

  services.cpupower-gui.enable = true;

  boot = {
    kernelPackages = pkgs.linuxPackages_latest;

    initrd = {
      systemd.enable = true;
      availableKernelModules = ["xhci_pci" "ahci" "nvme" "usbhid" "kvm-intel"];
      luks = {
        devices.${luksDevice} = {
          device = "/dev/disk/by-partlabel/LINUX_LUKS";
        };
      };
    };

    binfmt.emulatedSystems = [
      "aarch64-linux"
    ];

    kernel.sysctl = {"vm.swappiness" = 10;};

    kernelParams = [];

    loader = {
      systemd-boot = {
        enable = lib.mkForce false;
        # editor = false;
        # configurationLimit = 10;
        # consoleMode = "max";
      };
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot";
      };
    };

    tmp.useTmpfs = true;

    lanzaboote = {
      enable = true;
      pkiBundle = "/var/lib/secrets/secureboot";
    };
  };

  fileSystems = {
    "/" = {
      device = "/dev/mapper/${luksDevice}";
      fsType = "xfs";
      options = ["noatime"];
    };

    ${config.boot.loader.efi.efiSysMountPoint} = {
      device = "/dev/disk/by-partlabel/LINUX_ESP";
      fsType = "vfat";
      options = ["x-systemd.automount" "x-systemd.mount-timeout=15min" "umask=077"];
    };
  };

  environment.systemPackages = [
    pkgs.vault
    self'.packages.wezterm
    pkgs.sbctl
    pkgs.prismlauncher
  ];
}
