{ config, pkgs, ... }:

{
  users.mutableUsers = false; # change passwords of users

  users.users.mainUser = {
    name = "ayats";
    # initialPassword = "1234";
    createHome = true;
    home = "/home/ayats";
    description = "Fernando Ayats";
    isNormalUser = true;
    extraGroups = [ "wheel" "audio" "video" "uucp" "systemd-journal" "networkmanager" ];
    passwordFile = "/secrets/password/ayats";
  };

  home-manager.users.mainUser = { ... }: { };

  # programs.ssh.startAgent = true;
  # security.sudo.wheelNeedsPassword = false;
  security.sudo = {
    extraRules = [
      {
        groups = [ "wheel" ];
        commands = [
          {
            command = "${pkgs.nixos-rebuild}/bin/nixos-rebuild";
            options = [ "SETENV" "NOPASSWD" ];
          }
        ];
      }
    ];

  };

  services.openssh = {
    enable = true;
    listenAddresses = [
      {
        addr = "192.168.122.1";
        port = 22;
      }
    ];
  };

  systemd.tmpfiles.rules =
    let
      ho = config.users.users.mainUser.home;
      us = config.users.users.mainUser.name;
      gr = config.users.users.mainUser.group;
    in
    [
      "z /secrets/ssh 0700 ${us} ${gr} - -"
      "z /secrets/ssh/config 0600 ${us} ${gr} - -"
      "z /secrets/ssh/id_rsa 0400 ${us} ${gr} - -"
      "z /secrets/ssh/id_rsa.pub 0600 ${us} ${gr} - -"
      "z /secrets/ssh/known_hosts 0600 ${us} ${gr} - -"
      "L+ ${ho}/.ssh - - - - /secrets/ssh"
    ];

  systemd.services.bind-ssh = {
    serviceConfig.Type = "forking";
    script = ''
      ${pkgs.bindfs}/bin/bindfs --map=1000/0:@100/@0 -p ugo-x /secrets/ssh /root/.ssh
    '';
    wantedBy = [ "multi-user.target" ];
  };
}
