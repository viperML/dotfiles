{
  self,
  pkgs,
  lib,
  ...
}: let
  inherit (pkgs) system;
  target = "/home/nixos/dotfiles";
in {
  boot.kernelPackages = pkgs.linuxPackages_latest;

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
  boot.plymouth.enable = true;

  services.xserver = {
    desktopManager.plasma5 = {
      enable = true;
    };
    displayManager = {
      sddm.enable = true;
      autoLogin = {
        enable = true;
        user = "nixos";
      };
    };
  };

  systemd.tmpfiles.rules = [
    "C ${target} - - - - ${self}"
    "Z ${target} 0774 nixos nixos - -"
  ];

  environment.etc."gitconfig".text = ''
    [safe]
        directory = ${target}
  '';

  nix = {
    package = self.packages.${system}.nix;
    extraOptions = ''
      ${builtins.readFile "${self.outPath}/misc/nix.conf"}
    '';
  };

  environment.systemPackages = [
    pkgs.firefox
    self.packages.${system}.vshell
    self.packages.${system}.neovim
  ];

  isoImage.edition = "plasma5";
  isoImage.isoName = "nixos.iso";
  systemd.services.sshd.wantedBy = lib.mkForce ["multi-user.target"];
}
