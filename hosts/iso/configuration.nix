{
  self,
  pkgs,
  lib,
  packages,
  config,
  ...
}: let
  inherit (pkgs) system;
in {
  security.polkit.extraConfig = ''
    polkit.addRule(function(action, subject) {
      if (subject.isInGroup("wheel")) {
        return polkit.Result.YES;
      }
    });
  '';

  services.xserver.enable = true;
  networking.networkmanager.enable = true;
  networking.wireless.enable = lib.mkForce false;
  powerManagement.enable = true;
  hardware.pulseaudio.enable = true;
  services.spice-vdagentd.enable = true;
  boot.plymouth.enable = false;

  services.xserver = {
    desktopManager.plasma5 = {
      enable = true;
    };
    displayManager = {
      sddm.enable = true;
      autoLogin = {
        enable = false;
      };
    };
  };

  users.users.nixos.password = "nixos";

  systemd.tmpfiles.rules = [
    "C ${config.users.users.nixos.home}/dotfiles - - - - ${self}"
    "Z ${config.users.users.nixos.home}/dotfiles 0774 nixos nixos - -"
  ];

  environment.etc."gitconfig".text = ''
    [safe]
        directory = ${config.users.users.nixos.home}/dotfiles
  '';

  nix = {
    package = packages.self.nix;
    extraOptions = builtins.readFile "${self.outPath}/misc/nix.conf";
  };

  environment.systemPackages = [
    pkgs.firefox
    packages.self.zsh
    packages.self.neovim
  ];

  isoImage.edition = "plasma5";
  isoImage.isoName = "nixos.iso";
  systemd.services.sshd.wantedBy = lib.mkForce ["multi-user.target"];
}
