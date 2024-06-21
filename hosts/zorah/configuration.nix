{
  lib,
  pkgs,
  config,
  ...
}: let
  luksDevice = "luksroot";
in {
  environment.systemPackages = [
    pkgs.powertop
    pkgs.openconnect
  ];

  environment.sessionVariables = {NIXOS_OZONE_WL = "1";};

  networking = {
    hostName = "zorah";
    networkmanager = {
      enable = true;
      dns = "systemd-resolved";
    };
    nftables.enable = true;
    firewall.enable = false;
  };

  services.resolved = {enable = true;};

  security.sudo.wheelNeedsPassword = false;

  system.stateVersion = "23.11";

  # powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";

  hardware = {
    cpu.intel.updateMicrocode = true;
    # enableAllFirmware = true;
    enableRedistributableFirmware = true;
    bluetooth.enable = true;
    opengl = {
      enable = true;
      extraPackages = [pkgs.intel-media-driver];
    };
  };

  services.fwupd.enable = true;
  services.kmscon.enable = lib.mkForce false;

  # services.cpupower-gui.enable = true;
  # services.flatpak.enable = true;

  services.flatpak = {enable = true;};

  services.printing = {enable = true;};

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
    };

    kernelParams = [];

    kernelModules = ["kvm-intel"];

    loader = {
      systemd-boot.enable = lib.mkForce false;
      grub.enable = lib.mkForce false;
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot";
      };
      # timeout = 1;
    };

    tmp.useTmpfs = true;
  };

  fileSystems = {
    "/" = {
      device = "/dev/mapper/${luksDevice}";
      fsType = "xfs";
      options = ["noatime"];
    };

    ${config.boot.loader.efi.efiSysMountPoint} = {
      device = "/dev/disk/by-partlabel/ESP";
      fsType = "vfat";
      options = ["x-systemd.automount" "x-systemd.mount-timeout=15min" "umask=077"];
    };
  };
  # specialisation."nvidia" = {
  #   configuration = {
  #     environment.etc."specialisation".text = "nvidia";
  #     imports = [./nvidia.nix];
  #   };
  # };

  systemd.services."openconnect-inria" = {
    wantedBy = ["multi-user.target"];
    after = ["NetworkManager.service"];
    path = [pkgs.openconnect];
    script = ''
      openconnect vpn.inria.fr -u fayatsll --passwd-on-stdin < /var/lib/secrets/vpn-pw
    '';
  };
}
