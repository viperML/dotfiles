{
  lib,
  pkgs,
  config,
  ...
}: let
  luksDevice = "luksroot";
in {
  system.stateVersion = "24.05";
  environment.sessionVariables.FLAKE = "/var/home/ayats/Documents/dotfiles";

  environment.systemPackages = [
    pkgs.sbctl
    pkgs.powertop
    pkgs.sysfsutils
    pkgs.blender-hip
    pkgs.freecad-wayland
  ];

  # environment.sessionVariables = {NIXOS_OZONE_WL = "1";};

  networking = {
    hostName = "fatalis";
    networkmanager = {
      enable = true;
      # dns = "systemd-resolved";
    };
    nftables.enable = true;
  };

  # services.resolved = {
  #   enable = true;
  # };

  security.sudo.wheelNeedsPassword = false;

  # powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";

  hardware = {
    cpu.amd.updateMicrocode = true;
    enableRedistributableFirmware = true;
    bluetooth.enable = true;
    graphics = {
      enable = true;
      extraPackages = with pkgs.rocmPackages; [clr clr.icd];
    };
  };

  # services.fwupd.enable = true;

  # services.cpupower-gui.enable = true;
  # services.flatpak.enable = true;

  boot = {
    lanzaboote = {
      enable = true;
      pkiBundle = "/var/lib/secrets/secureboot";
      # pkiBundle = "/etc/secureboot";
    };

    kernelPackages = pkgs.linuxPackages_latest;

    initrd = {
      systemd.enable = true;
      availableKernelModules = [];

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

    loader = {
      systemd-boot.enable = lib.mkForce false;
      # systemd-boot.enable = true;
      grub.enable = lib.mkForce false;
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot";
      };
      # timeout = 1;
    };

    tmp.useTmpfs = true;

    # https://github.com/lwfinger/rtw89/blob/main/70-rtw89.conf
    # https://github.com/lwfinger/rtw89/tree/main?tab=readme-ov-file#option-configuration
    extraModprobeConfig = ''
      # set options for faulty HP and Lenovo BIOS code
      options rtw89_pci disable_aspm_l1=y disable_aspm_l1ss disable_clkreq=y
      options rtw89pci disable_aspm_l1=y disable_aspm_l1ss disable_clkreq=y
      options rtw89_core disable_ps_mode=y
    '';

    # binfmt.emulatedSystems = ["aarch64-linux"];
  };

  fileSystems = {
    "/" = {
      device = "/dev/mapper/${luksDevice}";
      fsType = "btrfs";
      options = ["noatime"];
    };

    ${config.boot.loader.efi.efiSysMountPoint} = {
      device = "/dev/disk/by-partlabel/EFI";
      fsType = "vfat";
      options = ["x-systemd.automount" "x-systemd.mount-timeout=15min" "umask=077"];
    };
  };

  programs.kde-pim.enable = false;

  programs.steam = {
    enable = true;
  };
}
