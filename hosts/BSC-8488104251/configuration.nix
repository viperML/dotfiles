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
    LIBVA_DRIVER_NAME = "iHD";
    DOCKER_BUILDKIT = "1";
  };

  nix.settings = {
    cores = 6;
  };

  users.users.ayats = {
    home = "/x";
    maid = {
      file.xdg_config."autostart/rocketchat-desktop.desktop".source =
        "/run/current-system/sw/share/applications/rocketchat-desktop.desktop";

      file.xdg_config."autostart/Mailspring.desktop".source =
        "/run/current-system/sw/share/applications/Mailspring.desktop";
    };
  };

  programs.firefox.enable = true;

  environment.systemPackages = [
    pkgs.vesktop
    pkgs.rocketchat-desktop
    pkgs.openfortivpn
    pkgs.zoom-us
    pkgs.glab
    pkgs.kaniko
    pkgs.keyd
    pkgs.mailspring

    pkgs.foot
  ];

  networking.hostName = "BSC-8488104251";

  security.sudo.wheelNeedsPassword = false;

  hardware = {
    enableRedistributableFirmware = true;
    bluetooth.enable = true;
    graphics = {
      enable = true;
      extraPackages = [
        pkgs.intel-media-driver
        pkgs.vpl-gpu-rt
      ];
    };
  };

  # services.fwupd.enable = true;

  # services.cpupower-gui.enable = true;
  # services.flatpak.enable = true;

  boot = {
    # plymouth = {
    #   enable = true;
    # };

    kernelPackages = pkgs.linuxPackages_latest;

    initrd = {
      systemd.enable = true;
      availableKernelModules = [ ];
    };

    kernelParams = [
      # "quiet"
      # # Send logs to tty2
      # "fbcon=vc:2-6"
      # "console=tty0"
      # "plymouth.use-simpledrm"
    ];

    kernel.sysctl = {
      "net.ipv4.conf.all.mc_forwarding" = true;
    };

    loader = {
      systemd-boot = {
        enable = true;
      };
      grub.enable = lib.mkForce false;
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot";
      };
      timeout = 0;
    };

    tmp.useTmpfs = true;

    binfmt.preferStaticEmulators = true;
    binfmt.emulatedSystems = [
      "aarch64-linux"
      "riscv64-linux"
    ];
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

  services.fwupd.enable = true;

  services.flatpak.enable = true;

  programs.singularity = {
    enable = true;
    package = pkgs.apptainer;
  };

  hardware.openrazer.enable = true;
  users.groups.openrazer.members = config.users.groups.wheel.members;

  systemd.services.tailscaled.serviceConfig.WantedBy = lib.mkForce [];
}
