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
  system.stateVersion = "24.05";
  environment.sessionVariables = rec {
    D = "/x/src/dotfiles";
    NH_FILE = "${D}/hosts/fatalis";
  };

  users.users.ayats = {
    home = "/x";
    maid = { };
  };

  environment.systemPackages = [
    pkgs.prismlauncher
  ];

  networking = {
    hostName = "fatalis";
  };

  hardware = {
    cpu.amd.updateMicrocode = true;
    graphics.extraPackages = [
      pkgs.rocmPackages.clr
      pkgs.rocmPackages.clr.icd
    ];
  };

  boot = {
    kernelModules = [
      "rtw89_8852ce"
    ];

    lanzaboote = {
      enable = true;
      pkiBundle = "/var/lib/secrets/secureboot";
    };

    initrd.luks.devices.${luksDevice} = {
      device = "/dev/disk/by-partlabel/LINUX_LUKS";
    };

    loader = {
      systemd-boot = {
        enable = lib.mkForce false;
        editor = false;
      };
      grub.enable = lib.mkForce false;
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot";
      };
    };

    # https://github.com/lwfinger/rtw89/blob/main/70-rtw89.conf
    # https://github.com/lwfinger/rtw89/tree/main?tab=readme-ov-file#option-configuration
    extraModprobeConfig = ''
      # set options for faulty HP and Lenovo BIOS code
      options rtw89_pci disable_aspm_l1=y disable_aspm_l1ss disable_clkreq=y
      options rtw89pci disable_aspm_l1=y disable_aspm_l1ss disable_clkreq=y
      options rtw89_core disable_ps_mode=y
    '';

    binfmt.emulatedSystems = [
      "aarch64-linux"
    ];
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
      device = "/dev/disk/by-partlabel/EFI";
      fsType = "vfat";
      options = [
        "x-systemd.automount"
        "x-systemd.mount-timeout=15min"
        "umask=077"
      ];
    };
  };

  programs.steam = {
    enable = true;
    gamescopeSession.enable = true;
  };

  programs.gamemode.enable = true;
}
