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
  home-manager.users.mainUser = _: {
    home.sessionVariables = {inherit FLAKE;};
  };

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

  services.tailscale.enable = true;

  systemd.tmpfiles.rules = let
    inherit (config.users.users.mainUser) group name home;
  in [
    "z /secrets/ssh 0700 ${name} ${group} - -"
    "z /secrets/ssh/config 0600 ${name} ${group} - -"
    "z /secrets/ssh/id_ed25519 0600 ${name} ${group} - -"
    "z /secrets/ssh/id_ed25519.pub 0644 ${name} ${group} - -"
    "z /secrets/ssh/known_hosts 0600 ${name} ${group} - -"
    "d /root/.ssh 0700 root root - -"
    "L+ ${home}/.ssh - - - - /secrets/ssh"
    #
    "L+ /etc/ssh/ssh_host_ed25519_key - - - - /secrets/ssh_host/ssh_host_ed25519_key"
    "L+ /etc/ssh/ssh_host_ed25519_key.pub - - - - /secrets/ssh_host/ssh_host_ed25519_key.pub"
    "L+ /etc/ssh/ssh_host_rsa_key - - - - /secrets/ssh_host/ssh_host_rsa_key"
    "L+ /etc/ssh/ssh_host_rsa_key.pub - - - - /secrets/ssh_host/ssh_host_rsa_key.pub"
  ];
  systemd.services.bind-ssh = {
    serviceConfig.Type = "forking";
    script = ''
      ${pkgs.bindfs}/bin/bindfs --map=1000/0:@100/@0 -p ugo-x /secrets/ssh /root/.ssh
    '';
    wantedBy = ["multi-user.target"];
  };

  nix.buildMachines = [
    {
      hostName = "gen6";
      system = "x86_64-linux";
      maxJobs = 16;
      speedFactor = 2;
      supportedFeatures = ["nixos-test" "benchmark" "big-parallel" "kvm"];
      mandatoryFeatures = [];
    }
  ];
  nix.distributedBuilds = true;
  nix.extraOptions = ''
    builders-use-substitutes = true
  '';
}
