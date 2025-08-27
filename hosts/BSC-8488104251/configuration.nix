{
  lib,
  pkgs,
  config,
  ...
}:
{
  system.stateVersion = "25.05";
  environment.sessionVariables = rec {
    D = "/x/src/dotfiles";
    NH_FILE = "${D}/hosts/BSC-8488104251";
    BUILDAH_FORMAT = "docker";
  };

  users.users.ayats = {
    home = "/x";
    maid = {
      file.xdg_config."autostart/rocketchat-desktop.desktop".source =
        "/run/current-system/sw/share/applications/rocketchat-desktop.desktop";
    };
  };

  environment.systemPackages = [
    pkgs.zen-browser
    pkgs.webcord
    pkgs.distrobox
    pkgs.windsurf
    pkgs.thunderbird
    pkgs.rocketchat-desktop
    pkgs.openfortivpn
    pkgs.zoom-us
    pkgs.buildah
    pkgs.skopeo
    pkgs.glab
    pkgs.polychromatic
  ];

  # environment.sessionVariables = {NIXOS_OZONE_WL = "1";};

  networking = {
    hostName = "BSC-8488104251";
    networkmanager = {
      enable = true;
      # dns = "systemd-resolved";
      plugins = with pkgs; [
        networkmanager-fortisslvpn
        networkmanager-openconnect
      ];
    };
    nftables.enable = true;
  };

  security.sudo.wheelNeedsPassword = false;

  # powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";

  hardware = {
    # cpu.amd.updateMicrocode = true;
    enableRedistributableFirmware = true;
    bluetooth.enable = true;
    graphics = {
      enable = true;
      # extraPackages = with pkgs.rocmPackages; [
      #   clr
      #   clr.icd
      # ];
    };
  };

  # services.fwupd.enable = true;

  # services.cpupower-gui.enable = true;
  # services.flatpak.enable = true;

  boot = {
    # lanzaboote = {
    #   enable = true;
    #   pkiBundle = "/var/lib/secrets/secureboot";
    #   # pkiBundle = "/etc/secureboot";
    # };

    # plymouth = {
    #   enable = true;
    # };

    kernelPackages = pkgs.linuxPackages_latest;

    initrd = {
      # kernelModules = ["amdgpu"];
      systemd.enable = true;
      availableKernelModules = [ ];

      # luks = {
      #   devices.${luksDevice} = {
      #     device = "/dev/disk/by-partlabel/LINUX_LUKS";
      #   };
      # };
    };

    kernel.sysctl = {
      # "vm.swappiness" = 100;
    };

    kernelParams = [
      # "quiet"
      # # Send logs to tty2
      # "fbcon=vc:2-6"
      # "console=tty0"
      # "plymouth.use-simpledrm"
    ];

    loader = {
      systemd-boot = {
        # enable = lib.mkForce false;
        enable = true;
        # consoleMode = "auto";
        # editor = false;
      };
      # systemd-boot.enable = true;
      grub.enable = lib.mkForce false;
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot";
      };
      timeout = 0;
    };

    tmp.useTmpfs = true;

    # https://github.com/lwfinger/rtw89/blob/main/70-rtw89.conf
    # https://github.com/lwfinger/rtw89/tree/main?tab=readme-ov-file#option-configuration
    # extraModprobeConfig = ''
    #   # set options for faulty HP and Lenovo BIOS code
    #   options rtw89_pci disable_aspm_l1=y disable_aspm_l1ss disable_clkreq=y
    #   options rtw89pci disable_aspm_l1=y disable_aspm_l1ss disable_clkreq=y
    #   options rtw89_core disable_ps_mode=y
    # '';

    # binfmt.emulatedSystems = [
    #   "aarch64-linux"
    # ];
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-partlabel/LINUX_ROOT";
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

  programs.kde-pim.enable = false;

  # programs.steam.enable = true;
  # programs.steam.gamescopeSession.enable = true;
  # programs.gamemode.enable = true;

  services.fwupd.enable = true;

  services.flatpak.enable = true;

  programs.singularity = {
    enable = true;
    package = pkgs.apptainer;
  };

  hardware.openrazer.enable = true;
  users.groups.openrazer.members = config.users.groups.wheel.members;
}
