{ config, pkgs, ... }:
let
  name = "ayats";
  home = "/home/ayats";
in
{
  users.mutableUsers = false; # change passwords of users

  users.users.mainUser = {
    inherit name home;
    createHome = true;
    description = "Fernando Ayats";
    isNormalUser = true;
    extraGroups = [ "wheel" "audio" "video" "uucp" "systemd-journal" "networkmanager" ];
    passwordFile = "/secrets/password/ayats";
  };

  # Enable home-manager for the user (inherit shared modules)
  home-manager.users.mainUser = { ... }: { };

  security.sudo. extraRules = [{
    groups = [ "wheel" ];
    commands = [
      {
        command = "${pkgs.nixos-rebuild}/bin/nixos-rebuild";
        options = [ "SETENV" "NOPASSWD" ];
      }
    ];
  }];

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
      group = config.users.users.mainUser.group;
    in
    [
      "z /secrets/ssh 0700 ${name} ${group} - -"
      "z /secrets/ssh/config 0600 ${name} ${group} - -"
      "z /secrets/ssh/id_ed25519 0600 ${name} ${group} - -"
      "z /secrets/ssh/id_ed25519.pub 0644 ${name} ${group} - -"
      "z /secrets/ssh/known_hosts 0600 ${name} ${group} - -"
      "d /root/.ssh 0700 root root - -"
      "L+ ${home}/.ssh - - - - /secrets/ssh"
    ];

  # Bind keys to the root users
  # This fixes building on remote machines
  systemd.services.bind-ssh = {
    serviceConfig.Type = "forking";
    script = ''
      ${pkgs.bindfs}/bin/bindfs --map=1000/0:@100/@0 -p ugo-x /secrets/ssh /root/.ssh
    '';
    wantedBy = [ "multi-user.target" ];
  };
}
