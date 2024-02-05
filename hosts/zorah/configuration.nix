{
  lib,
  pkgs,
  config,
  ...
}: {
  environment.systemPackages = [
    pkgs.sbctl
    pkgs.dmidecode
    pkgs.powertop
    pkgs.pam_u2f
    pkgs.yubikey-manager
  ];

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
  };

  networking = {
    hostName = "zorah";
    networkmanager = {
      enable = true;
      dns = "systemd-resolved";
    };
  };

  services.resolved = {
    enable = true;
  };

  security.sudo.wheelNeedsPassword = false;

  system.stateVersion = "23.11";

  # powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";

  hardware = {
    cpu.intel.updateMicrocode = true;
    enableAllFirmware = true;
    bluetooth.enable = true;
    opengl = {
      enable = true;
      extraPackages = [
        pkgs.intel-media-driver
      ];
    };
  };

  services.fwupd.enable = true;
  services.kmscon.enable = lib.mkForce false;

  # services.cpupower-gui.enable = true;
  # services.flatpak.enable = true;

  security.pam.u2f = {
    enable = true;
    origin = "pam://${config.networking.hostName}";
    appId = "pam://${config.networking.hostName}";
    cue = true;
  };
}
