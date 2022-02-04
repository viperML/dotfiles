{ config, pkgs, lib, ... }:
{
  services.gnome.gnome-keyring.enable = true;
  programs.ssh.startAgent = true;
  programs.ssh.agentTimeout = "3h";

  # environment.variables.SSH_ASKPASS = lib.mkForce "${pkgs.gnome.seahorse}/libexec/seahorse/ssh-askpass";
  environment.variables.SSH_ASKPASS_REQUIRE = "prefer";

  home-manager.sharedModules = [{
    # programs.git.extraConfig.credential.helper = "${pkgs.gitAndTools.gitFull}/bin/git-credential-libsecret";
    # services.gnome-keyring = {
    #   enable = true;
    #   components = [ "pkcs11" "secrets" "ssh" ];
    # };
    # home.sessionVariables.SSH_AUTH_SOCK = "$XDG_RUNTIME_DIR/keyring/ssh";
    # home.sessionVariables.SSH_ASKPASS = "${pkgs.gnome.seahorse}/libexec/seahorse/ssh-askpass";
    # home.packages = with pkgs; [
    #   libgnome-keyring
    #   gnome.seahorse
    # ];
    }];

  environment.systemPackages = [
    pkgs.gnome.seahorse
    pkgs.libsForQt5.kwalletmanager
  ];
}
