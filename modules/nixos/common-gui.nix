{
  pkgs,
  lib,
  ...
}:
{
  imports = [
    ./swap.nix
    ./common-console.nix
  ];

  services.udev.packages = with pkgs; [
    geteduroam-cli
    ddcutil
  ];

  boot = {
    initrd.systemd.enable = true;
    kernelPackages = lib.mkDefault pkgs.linuxPackages_latest;
    binfmt.preferStaticEmulators = true;
  };

  services.fwupd.enable = true;

  hardware = {
    enableRedistributableFirmware = true;
    bluetooth.enable = true;
    graphics.enable = true;
    i2c.enable = true;
  };

  environment.systemPackages = with pkgs; [
    # CLI desktop tools
    usbutils # lsusb
    pciutils # lspci
    efibootmgr
    android-tools
    geteduroam-cli
    ddcutil

    # GUI
    mpv
    vscode
    wl-color-picker
    vial
    alacritty
    obsidian
    mpv

    # AI
    opencode
    antigravity
  ];

  systemd = {
    services."getty@tty1".enable = false;
    services."autovt@tty1".enable = false;
    services."getty@tty7".enable = false;
    services."autovt@tty7".enable = false;
    services."kmsconvt@tty1".enable = false;
    services."kmsconvt@tty7".enable = false;
  };

  fonts.packages = [
    pkgs.inter
    pkgs.iosevka-normal
    pkgs.nerd-fonts.symbols-only
    pkgs.corefonts
  ];

  services.xserver = {
    enable = true;
    xkb = {
      layout = "es";
      options = "compose:rctrl";
    };
    excludePackages = [ pkgs.xterm ];
  };

  services.libinput = {
    enable = true;
    mouse.accelProfile = "flat";
    mouse.accelSpeed = "0.0";
    mouse.middleEmulation = false;
  };

  console.useXkbConfig = true;

  hardware.steam-hardware.enable = true;
  hardware.keyboard.qmk.enable = true;

  services.hardware.bolt.enable = true;

  networking = {
    networkmanager = {
      enable = true;
      plugins = [
        pkgs.networkmanager-openconnect
      ];
    };
    nftables.enable = true;
  };
}
