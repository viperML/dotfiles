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

  # users.users = pkgs.lib.mkMerge (
  #   [{ root.passwordFile = "/secrets/password/root"; }] ++
  #   forEach config.users (u:
  #     { "${u}".passwordFile = "/secrets/password/${u}"; }
  #   )
  # );
}
