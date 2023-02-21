{
  config,
  lib,
  pkgs,
  ...
}: {
  boot = {
    kernelPackages = pkgs.linuxPackages_latest;

    initrd = {
      systemd.enable = true;
      availableKernelModules = [
        "xhci_pci"
        "ahci"
        "nvme"
        "usbhid"
        "amdgpu"
        "kvm-intel"
      ];
      supportedFilesystems = ["btrfs"];
    };

    loader = {
      systemd-boot = {
        enable = true;
        consoleMode = "max";
      };
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/efi";
      };
      timeout = 1;
    };

    tmpOnTmpfs = true;

    binfmt.emulatedSystems = [
      "aarch64-linux"
      "wasm32-wasi"
    ];
  };

  networking = {
    hostName = "UCD61NBT9B46HEYTS9CU3JPMQ4HIJZ2FQ6263HFLZF8TCNU2IQ48EGOJS9H5XTY";
    hostId = builtins.substring 0 8 (builtins.hashString "md5" config.networking.hostName);
    networkmanager.enable = true;
    # Strict reverse path filtering breaks Tailscale exit node use and some subnet routing setups.
    firewall.checkReversePath = "loose";
  };

  environment.systemPackages = [
    config.packages.nh.default
    config.packages.self.git
  ];

  users.mutableUsers = false;
  users.users.ayats = {
    isNormalUser = true;
    extraGroups = ["wheel"];
    password = "1234";
    createHome = true;
  };

  security.sudo.wheelNeedsPassword = false;

  fileSystems = let
    mkBtrfs = extraOpts: {
      device = "/dev/disk/by-label/LINUX_ROOT";
      fsType = "btrfs";
      options = ["noatime" "compress=lzo"] ++ extraOpts;
    };
  in {
    "/" = {
      device = "none";
      fsType = "tmpfs";
      options = [
        "defaults"
        "size=4G"
        "mode=0755"
      ];
    };

    ${config.boot.loader.efi.efiSysMountPoint} = {
      device = "/dev/disk/by-label/LINUX_ESP";
      fsType = "vfat";
      options = [
        "x-systemd.automount"
        "x-systemd.mount-timeout=15min"
        "umask=077"
      ];
    };

    "/nix" = mkBtrfs ["subvol=/@nixos/@nix"];
    "/var" = mkBtrfs ["subvol=/@nixos/@var"];
    "/home" = mkBtrfs ["subvol=/@home"];
  };

  swapDevices = [
    {
      label = "LINUX_SWAP";
    }
  ];

  time.timeZone = "Europe/Madrid";

  nixpkgs.hostPlatform = "x86_64-linux";
  nixpkgs.config.allowUnfree = true;
  system.stateVersion = "22.11";

  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";

  hardware = {
    cpu.intel.updateMicrocode = true;
    enableRedistributableFirmware = true;
    video.hidpi.enable = true;
    bluetooth.enable = true;
    opengl = {
      enable = true;
      extraPackages = with pkgs; [
        # TODO
        # rocm-opencl-icd
        # rocm-opencl-runtime
        # amdvlk
      ];
    };
  };

  services.xserver = {
    enable = true;
    layout = "es";
    xkbOptions = "compose:rctrl";
    libinput = {
      enable = true;
      mouse.accelProfile = "flat";
      mouse.accelSpeed = "0.0";
    };
    videoDrivers = ["amdgpu"];
    displayManager = {
      autoLogin.user = "ayats";
    };
  };

  console = {
    font = "ter-v20n";
    packages = [pkgs.terminus_font];
    useXkbConfig = true;
    earlySetup = false;
  };

  # https://flokli.de/posts/2022-11-18-nsncd
  services.nscd.enableNsncd = true;

  home-manager.users.ayats = {
    imports = [
      ./home.nix
    ];
  };
}
