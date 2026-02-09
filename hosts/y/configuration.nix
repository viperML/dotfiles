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
    NH_FILE = "${D}/hosts/y";
    LIBVA_DRIVER_NAME = "iHD";
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

      systemd.tmpfiles.dynamicRules = [
        "D {{xdg_runtime_dir}}/gitlab-runner 0755 {{user}} {{group}} - -"
        "L {{home}}/.gitlab-runner - - - - {{xdg_runtime_dir}}/gitlab-runner"
      ];
    };
  };

  environment.systemPackages = [
    pkgs.rocketchat-desktop
    pkgs.openfortivpn
    pkgs.zoom-us
    pkgs.kaniko
    pkgs.mailspring
    pkgs.google-chrome
    pkgs.foot
    (pkgs.python3.withPackages (pp: [ ]))
    pkgs.gocryptfs
    pkgs.oras
  ];

  networking = {
    hostName = "y";
  };

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

  boot = {
    kernelPackages = pkgs.linuxPackages_latest;

    initrd = {
      systemd.enable = true;
      luks.devices."luksroot".device = "/dev/disk/by-partlabel/LINUX_LUKS";
      availableKernelModules = [
        "xhci_pci"
        "thunderbolt"
        "nvme"
        "usb_storage"
        "usbhid"
        "sd_mod"
      ];
      extraFirmwarePaths = [
        "iwlwifi-gl-c0-fm-c0-101.ucode.zst"
        "iwlwifi-gl-c0-fm-c0-100.ucode.zst"
      ];
    };

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
        efiSysMountPoint = "/efi";
      };
      timeout = 0;
    };

    tmp.useTmpfs = true;

    binfmt.preferStaticEmulators = true;
    binfmt.emulatedSystems = [
      "aarch64-linux"
    ];
  };

  fileSystems = {
    "/" = {
      device = "/dev/mapper/luksroot";
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

  systemd.services.tailscaled.serviceConfig.WantedBy = lib.mkForce [ ];
}
