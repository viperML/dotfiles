{
  config,
  pkgs,
  inputs,
  lib,
  ...
}: let
  FLAKE = "/home/ayats/Documents/dotfiles";
in {
  environment.variables = {inherit FLAKE;};
  environment.sessionVariables = {inherit FLAKE;};

  environment.systemPackages = with pkgs; [
    mpv
    android-tools
  ];

  boot = {
    initrd = {
      luks.devices = {
        tank = {
          device = "/dev/sda2";
          preLVM = true;
          # allowDiscards = true;
        };
      };

      availableKernelModules = [
        "xhci_pci"
        "ahci"
        "ohci_pci"
        "ehci_pci"
        "sd_mod"
        "sr_mod"
        "rtsx_pci_sdmmc"
      ];
      kernelModules = [
        "dm-snapshot"
      ];
    };
    tmpOnTmpfs = true;
    # kernelPackages = pkgs.linuxKernel.packages.linux_latest;
    kernelModules = ["kvm-amd"];

    loader.grub = {
      device = "nodev";
      enable = true;
      efiSupport = true;
      # gfxmodeEfi = "2560x1440";
      configurationLimit = 10;
      default = "saved";
    };

    loader.efi = {
      efiSysMountPoint = "/boot";
      canTouchEfiVariables = true;
    };
  };

  networking = {
    hostName = "noname";
    # hostId = "01017f00";
  };

  services.xserver = {
    layout = "es";
    displayManager.autoLogin.user = "ayats";
    libinput.enable = true;
  };

  fileSystems = {
    "/" = {
      device = "/dev/tankVG/rootfs";
      fsType = "ext4";
    };
    "/boot" = {
      device = "/dev/sda1";
      fsType = "vfat";
    };
  };

  swapDevices = [
    {
      device = "/dev/tankVG/swap";
    }
  ];

  powerManagement.cpuFreqGovernor = "schedutil";

  hardware = {
    cpu.amd.updateMicrocode = true;
    enableRedistributableFirmware = true;
    opengl.enable = true;
    opengl.driSupport = true;
  };

  programs = {
    xwayland.enable = true;
  };

  networking.networkmanager = {
    enable = true;
    dns = "default";
  };
}
