{ lib
, pkgs
, ...
}: {
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

  users.mutableUsers = false;
  users.users.ayats = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    password = "1234";
    createHome = true;
  };

  security.sudo.wheelNeedsPassword = false;

  system.stateVersion = "22.11";

  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";

  hardware = {
    cpu.intel.updateMicrocode = true;
    enableRedistributableFirmware = true;
    bluetooth.enable = true;
    opengl = {
      enable = true;
      extraPackages = with pkgs.rocmPackages; [
        clr
        clr.icd
      ];
    };
  };

  services.fwupd.enable = true;

  security.pam.services = {
    login.u2fAuth = true;
    sudo.u2fAuth = true;
  };

  services.thermald.enable = true;

  systemd.tmpfiles.rules = [
    "z /var/lib/secrets 0700 root root - -"
  ];

  services.cpupower-gui.enable = true;
}
