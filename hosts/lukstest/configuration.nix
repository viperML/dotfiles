{
  config,
  pkgs,
  lib,
  modulesPath,
  ...
}: {
  networking.hostName = "lukstest"; # Define your hostname.
  networking.networkmanager.enable = true;
  services.openssh.enable = true;
  networking.firewall.enable = false;
  users.users.ayats = {
    isNormalUser = true;
    extraGroups = ["wheel"]; # Enable ‘sudo’ for the user.
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIBZkBer8ozZ/6u7AQ1FHXiF1MbetEUKZoV5xN5YkhMo ayatsfer@gmail.com"
    ];
  };
  security.sudo.wheelNeedsPassword = false;
  environment.systemPackages = with pkgs; [
    git
    (pkgs.writeShellScriptBin "apply" ''
      nixos-rebuild boot --flake /mnt
    '')
    pciutils
    fzf
  ];
  system.stateVersion = "21.11";
  nix.package = pkgs.nix_2_4;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.initrd.systemd = {
    enable = true;
  };

  boot.initrd.availableKernelModules = ["ahci" "xhci_pci" "virtio_pci" "sr_mod" "virtio_blk"];
  boot.initrd.kernelModules = [
    "tpm_crb"
  ];
  boot.kernelModules = ["kvm-intel"];
  boot.extraModulePackages = [];

  fileSystems."/" = {
    device = "/dev/mapper/ROOTFS";
    fsType = "ext4";
  };
  fileSystems."/mnt" = {
    device = "dotfiles";
    fsType = "9p";
  };

  boot.initrd.luks.devices."ROOTFS" = {
    device = "/dev/vda2";
    crypttabExtraOpts = [
      "tpm2-device=auto"
    ];
  };

  security.tpm2 = {
    enable = true;
    abrmd.enable = true;
  };

  # Gen 25 works
}
