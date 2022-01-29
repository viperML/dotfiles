{ config, pkgs, lib, ... }:
{
  # services.gnome.gnome-keyring.enable = true;
  # programs.ssh.startAgent = true;

  environment.variables.SSH_ASKPASS = lib.mkForce "${pkgs.gnome.seahorse}/libexec/seahorse/ssh-askpass";

  home-manager.sharedModules = [{
    programs.git.extraConfig.credential.helper = "${pkgs.gitAndTools.gitFull}/bin/git-credential-libsecret";
    services.gnome-keyring = {
      enable = true;
      components = [ "pkcs11" "secrets" "ssh" ];
    };
    home.sessionVariables.SSH_AUTH_SOCK = "$XDG_RUNTIME_DIR/keyring/ssh";
  }];

  environment.systemPackages = [
    pkgs.gnome.seahorse
  ];
}
