{ config, pkgs, ... }:

{
  users.mutableUsers = true; # change passwords of users

  users.users.mainUser = {
    name = "ayats";
    initialPassword = "1234";
    home = "/home/ayats";
    description = "Fernando Ayats";
    isNormalUser = true;
    extraGroups = [ "wheel" "audio" "video" "uucp" "systemd-journal" "networkmanager" ];
    # passwordFile = config.sops.secrets."initialPassword/ayats".path;
  };

  programs.ssh.startAgent = true;

  security.pam.enableSSHAgentAuth = true;
  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIBZkBer8ozZ/6u7AQ1FHXiF1MbetEUKZoV5xN5YkhMo ayatsfer@gmail.com"
  ];
}
