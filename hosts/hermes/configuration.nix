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
  environment.sessionVariables = rec {
    D = "/x/src/dotfiles";
    NH_FILE = "${D}/hosts/hermes";
  };

  networking = {
    hostName = "hermes";
    networkmanager = {
      enable = true;
      dns = "systemd-resolved";
    };
    nftables.enable = true;
  };

  users.users.ayats = {
    home = "/x";
    maid = {
      # systemd.tmpfiles.dynamicRules = [
      #   "L /tmp/cursor-settings - - - - {{home}}/src/dotfiles/misc/cursor-settings"
      # ];
    };
  };

  services.resolved = {
    enable = true;
  };

  users.mutableUsers = lib.mkForce true;

  security.sudo.wheelNeedsPassword = false;

  system.stateVersion = "25.05";

  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";

  hardware = {
    cpu.intel.updateMicrocode = true;
    enableRedistributableFirmware = true;
    bluetooth.enable = true;
    graphics = {
      enable = true;
      extraPackages = with pkgs.rocmPackages; [
        clr
        clr.icd
      ];
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
      availableKernelModules = [
        "xhci_pci"
        "ahci"
        "nvme"
        "usbhid"
        "kvm-intel"
      ];
      luks = {
        devices.${luksDevice} = {
          device = "/dev/disk/by-partlabel/LINUX_ROOT";
        };
      };
    };

    binfmt.emulatedSystems = [
      "aarch64-linux"
    ];

    # kernel.sysctl = {
    #   "vm.swappiness" = 10;
    # };

    kernelParams = [ ];

    loader = {
      systemd-boot = {
        enable = lib.mkForce (!config.boot.lanzaboote.enable);
      };
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot";
      };
    };

    tmp.useTmpfs = true;

    lanzaboote = {
      enable = true;
      pkiBundle = "/var/lib/sbctl";
    };
  };

  fileSystems = {
    "/" = {
      device = "/dev/mapper/${luksDevice}";
      fsType = "btrfs";
      options = [
        "relatime"
        "lazytime"
      ];
    };

    ${config.boot.loader.efi.efiSysMountPoint} = {
      device = "/dev/disk/by-partlabel/LINUX_EFI";
      fsType = "vfat";
      options = [
        "x-systemd.automount"
        "x-systemd.mount-timeout=15min"
        "umask=077"
      ];
    };
  };

  environment.systemPackages = [
    pkgs.sbctl
    # pkgs.distrobox
    # pkgs.nvtopPackages.amd
    # pkgs.powertop
    # pkgs.sysfsutils
    pkgs.zen-browser
    pkgs.vesktop
    pkgs.distrobox
  ];
}
