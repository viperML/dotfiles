{ config, pkgs, lib, ... }:
{
  services.gnome.gnome-keyring.enable = true;
  programs.ssh.startAgent = true;

  environment.variables.SSH_ASKPASS = lib.mkForce "${pkgs.gnome.seahorse}/libexec/seahorse/ssh-askpass";

  home-manager.sharedModules = [{
    programs.git.extraConfig.credential.helper = "${pkgs.gitAndTools.gitFull}/bin/git-credential-libsecret";
  }];

  environment.systemPackages = [
    pkgs.gnome.seahorse
  ];
}
