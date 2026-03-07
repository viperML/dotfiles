{
  lib,
  pkgs,
  config,
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
  };

  users.users.ayats = {
    home = "/x";
  };

  system.stateVersion = "25.05";

  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";

  hardware = {
    cpu.intel.updateMicrocode = true;
    graphics.extraPackages = [
      pkgs.rocmPackages.clr
      pkgs.rocmPackages.clr.icd
    ];
  };

  boot = {
    initrd = {
      luks.devices.${luksDevice}.device = "/dev/disk/by-partlabel/LINUX_ROOT";
    };

    binfmt.emulatedSystems = [
      "aarch64-linux"
    ];

    loader = {
      systemd-boot = {
        enable = lib.mkForce (!config.boot.lanzaboote.enable);
      };
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot";
      };
    };

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
    pkgs.prismlauncher
  ];

  programs.steam = {
    enable = true;
    gamescopeSession.enable = true;
  };
}
