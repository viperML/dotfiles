# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }:

{


  imports =
    [
      (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot = {
    initrd = {
      availableKernelModules = [ "ahci" "nvme" "usbhid" ];
      kernelModules = [ ];
      supportedFilesystems = [ "zfs" ];
      # extraFiles."/etc/zfs/keys/zroot.key".source = /etc/zfs/keys/zroot.key;
    };
    supportedFilesystems = [ "zfs" ];
    kernelModules = [ "kvm-intel" ];
    extraModulePackages = [ ];

    zfs = {
      enableUnstable = true;
      forceImportAll = false;
      forceImportRoot = false;
    };

    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
  };

  networking = {
    hostName = "gen6";
    hostId = "01017f00";
    # useDHCP = true;
    # interfaces.eno1.useDHCP = true;
  };

  # nix = {
  #   extraOptions = ''
  #     max-jobs=8
  #   '';
  # };


  services = {
    xserver = {
      layout = "us";
      videoDrivers = [ "nvidia" ];
    };
  };

  fileSystems."/" =
    {
      device = "zroot/gen6/nixos";
      fsType = "zfs";
      options = [ "zfsutil" ];
    };

  fileSystems."/nix" =
    {
      device = "zroot/nix";
      fsType = "zfs";
      options = [ "zfsutil" ];
    };

  fileSystems."/boot" =
    {
      device = "/dev/disk/by-label/LINUXBOOT";
      fsType = "vfat";
    };

  swapDevices =
    [{ device = "/dev/disk/by-label/LINUXSWAP"; }];

  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  # high-resolution display
  hardware.video.hidpi.enable = lib.mkDefault true;
}
