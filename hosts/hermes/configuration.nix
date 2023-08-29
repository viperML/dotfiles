{
  config,
  lib,
  pkgs,
  packages,
  ...
}: {
  environment.sessionVariables = {
    VAULT_ADDR = "http://shiva:8200";
    NOMAD_ADDR = "http://shiva:4646";
  };

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
    };

    binfmt.emulatedSystems = [
      "aarch64-linux"
      "wasm32-wasi"
    ];

    kernel.sysctl = {
      "vm.swappiness" = 10;
    };
  };

  networking = {
    hostName = "hermes";
    networkmanager = {
      enable = true;
      dns = "systemd-resolved";
    };
    # Strict reverse path filtering breaks Tailscale exit node use and some subnet routing setups.
    firewall.checkReversePath = "loose";
  };

  services.resolved = {
    enable = true;
  };

  environment.systemPackages = [
    pkgs.cpupower-gui
  ];

  users.mutableUsers = false;
  users.users.ayats = {
    isNormalUser = true;
    extraGroups = ["wheel"];
    password = "1234";
    createHome = true;
  };

  security.sudo.wheelNeedsPassword = false;

  nixpkgs.hostPlatform = "x86_64-linux";
  system.stateVersion = "22.11";

  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";

  hardware = {
    cpu.intel.updateMicrocode = true;
    enableRedistributableFirmware = true;
    # video.hidpi.enable = true;
    bluetooth.enable = true;
    opengl = {
      enable = true;
      extraPackages = [
        pkgs.rocm-opencl-icd
        pkgs.rocm-opencl-runtime
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
      mouse.middleEmulation = false;
    };
    videoDrivers = ["amdgpu"];
  };

  console = {
    # Using kmscon
    # font = "ter-v20n";
    # packages = [pkgs.terminus_font];
    useXkbConfig = true;
  };

  # https://flokli.de/posts/2022-11-18-nsncd
  services.nscd.enableNsncd = true;

  services.fwupd.enable = true;

  security.pam.services = {
    login.u2fAuth = true;
    sudo.u2fAuth = true;
  };

  services.thermald.enable = true;
  services.cpupower-gui.enable = true;

  systemd.tmpfiles.rules = [
    "z /var/lib/secrets 0700 root root - -"
  ];

  services.kmscon = {
    enable = true;
    extraConfig = ''
      font-size=14
      xkb-layout=${config.services.xserver.layout}
    '';
    hwRender = true;
    fonts = [
      {
        name = "iosevka-normal Semibold";
        package = packages.self.iosevka;
      }
    ];
  };

  virtualisation.waydroid.enable = true;

  programs.darling.enable = true;
}
