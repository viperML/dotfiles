{
  lib,
  pkgs,
  ...
}: {
  environment.systemPackages = [
    pkgs.sbctl
    pkgs.dmidecode
  ];

  networking = {
    hostName = "fatalis";
    networkmanager = {
      enable = true;
    };
  };

  security.sudo.wheelNeedsPassword = false;

  system.stateVersion = "23.11";

  # powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";

  hardware = {
    cpu.amd.updateMicrocode = true;
    enableAllFirmware = true;
    bluetooth.enable = true;
    opengl = {
      enable = true;
      extraPackages = with pkgs.rocmPackages; [
        clr
        clr.icd
      ];
    };
  };

  # services.fwupd.enable = true;
  services.kmscon.enable = lib.mkForce false;

  # security.pam.services = {
  #   login.u2fAuth = true;
  #   sudo.u2fAuth = true;
  # };

  # services.thermald.enable = true;
  # services.cpupower-gui.enable = true;
}
