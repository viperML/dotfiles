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
  };

  programs.ssh.startAgent = true;
  security.sudo.wheelNeedsPassword = false;

}
