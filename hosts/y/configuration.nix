{
  lib,
  pkgs,
  config,
  ...
}:
{
  imports = [
    ./dell.nix
  ];

  system.stateVersion = "25.05";
  environment.sessionVariables = rec {
    D = "/x/src/dotfiles";
    NH_FILE = "${D}/hosts/y";
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
    (pkgs.python3.withPackages (pp: [ ]))
    pkgs.antigravity
    pkgs.geteduroam-cli
    pkgs.rsync
  ];

  networking = {
    hostName = "y";
  };

  boot = {
    initrd = {
      luks.devices."luksroot".device = "/dev/disk/by-partlabel/LINUX_LUKS";
      availableKernelModules = [
        "xhci_pci"
        "thunderbolt"
        "nvme"
        "usb_storage"
        "usbhid"
        "sd_mod"
      ];
    };

    loader = {
      systemd-boot.enable = true;
      grub.enable = lib.mkForce false;
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/efi";
      };
      timeout = 0;
    };

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

  programs.singularity = {
    enable = true;
    package = pkgs.apptainer;
  };

  systemd.services.tailscaled.serviceConfig.WantedBy = lib.mkForce [ ];
}
