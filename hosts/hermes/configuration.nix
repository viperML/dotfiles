{
  config,
  lib,
  pkgs,
  packages,
  ...
}: {
  # broken
  services.envfs.enable = lib.mkForce false;

  boot = {
    kernelPackages = pkgs.linuxPackages_latest;

    initrd = {
      systemd.enable = true;
      availableKernelModules = [
        "xhci_pci"
        "ahci"
        "nvme"
        "usbhid"
        # "amdgpu"
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

    kernelParams = [
      "quiet"
      "splash"
      "video=DP-1:2560x1440@144"
      "video=DP-2:2560x1440@144"
      "video=DP-3:2560x1440@144"
      "loglevel=3"
      "rd.udev.log_level=3"
      "systemd.show_status=0"
      "vt.global_cursor_default=0"
    ];
  };

  networking = {
    hostName = "hermes";
    networkmanager = {
      enable = true;
      dns = "systemd-resolved";
    };
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

  system.stateVersion = "22.11";

  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";

  hardware = {
    cpu.intel.updateMicrocode = true;
    enableRedistributableFirmware = true;
    # video.hidpi.enable = true;
    bluetooth.enable = true;
    opengl = {
      enable = true;
      extraPackages = with pkgs.rocmPackages; [
        clr
        clr.icd
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
    # videoDrivers = ["amdgpu"];
  };

  console = {
    # Using kmscon
    # font = "ter-v20n";
    # packages = [pkgs.terminus_font];
    useXkbConfig = true;
  };

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
}
