{ config, pkgs, ... }:

{
  users.mutableUsers = false; # change passwords of users

  users.users.mainUser = {
    name = "ayats";
    initialPassword = "1234";
    createHome = true;
    home = "/home/ayats";
    description = "Fernando Ayats";
    isNormalUser = true;
    extraGroups = [ "wheel" "audio" "video" "uucp" "systemd-journal" "networkmanager" ];
  };

  programs.ssh.startAgent = true;
  security.sudo.wheelNeedsPassword = false;
}
