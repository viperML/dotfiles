{
  name,
  uid,
}: {
  config,
  pkgs,
  inputs,
  packages,
  lib,
  ...
}: let
  home = "/home/${name}";
in {
  users.mutableUsers = false;

  users.users.${name} = {
    inherit name home;
    createHome = true;
    # description = "${name},,,,UMASK=077";
    description = name;
    isNormalUser = true;
    extraGroups = [
      "audio"
      "input"
      "networkmanager"
      "systemd-journal"
      "uucp"
      "video"
      "wheel"
    ];
    openssh.authorizedKeys.keys = [
    ];
    passwordFile = "/var/lib/secrets/users.passwd";
  };

  # security.pam.services.login.text = lib.mkDefault ''
  #   session optional pam_umask.so
  # '';

  security.sudo.extraRules = [
    {
      groups = ["wheel"];
      commands = [
        {
          command = "${pkgs.nixos-rebuild}/bin/nixos-rebuild";
          options = ["SETENV" "NOPASSWD"];
        }
        {
          command = "${packages.self.nh}/bin/nh";
          options = ["SETENV" "NOPASSWD"];
        }
      ];
    }
  ];

  # services.xserver.displayManager.autoLogin.user = name;
  # services.getty.autologinUser = name;

  nix.settings.trusted-users = ["${name}"];

  systemd.tmpfiles.rules =
    (lib.flatten (map (d: [
        "d ${home}/${d} 700 ${name} users - -"
        "z ${home}/${d} 700 ${name} users - -"
      ]) [
        ".config"
        ".local"
        ".local/share"
        ".cache"
        ".ssh"
        ".local/share/dot-steam"
        ".local/share/flatpak-var"
      ]))
    ++ [
      "L+ ${home}/.steampath - - - - ${home}/.steam/sdk32/steam"
      "L+ ${home}/.steampid - - - - ${home}/.steam/steam.pid"
    ];

  home-manager.users.${name} = {};

  viper.users = ["${name}"];

  services.xserver.displayManager = lib.mkIf ((builtins.length config.viper.users) == 1) {
    autoLogin.enable = true;
    autoLogin.user = name;
  };

  fileSystems = {
    "dot-steam-${name}" = {
      mountPoint = "${home}/.steam";
      device = "${home}/.local/share/dot-steam";
      options = ["bind"];
    };
    "flatpak-var-${name}" = {
      mountPoint = "${home}/.var";
      device = "${home}/.local/share/flatpak-var";
      options = ["bind"];
    };
  };
}
