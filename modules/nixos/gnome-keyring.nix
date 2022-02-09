{ config
, pkgs
, lib
, ...
}:
{
  services.gnome.gnome-keyring.enable = true;
  programs.ssh.startAgent = true;
  programs.ssh.agentTimeout = "3h";

  # environment.variables.SSH_ASKPASS = lib.mkForce "${pkgs.gnome.seahorse}/libexec/seahorse/ssh-askpass";
  environment.variables.SSH_ASKPASS_REQUIRE = "prefer";

  environment.systemPackages = [
    pkgs.gnome.seahorse
  ];
}
