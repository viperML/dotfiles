{
  name,
  uid,
}: {
  config,
  pkgs,
  packages,
  lib,
  ...
}: let
  home = "/home/${name}";
in {
  users.mutableUsers = false;

  users.users.${name} = {
    inherit name home uid;
    createHome = true;
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

  nix.settings.trusted-users = [name];

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
        ".local/share/dot-var"
        ".local/share/mozilla"

        "Desktop"
        "Documents"
        "Downloads"
        "Music"
        "Pictures"
        "Videos"
      ]))
    ++ [
      "L+ ${home}/.steampath - - - - ${home}/.steam/sdk32/steam"
      "L+ ${home}/.steampid - - - - ${home}/.steam/steam.pid"
    ];

  systemd.services."home-manager-${name}".serviceConfig.ExecStartPre = let
    file = "${home}/.config/fontconfig/conf.d/10-hm-fonts.conf";
  in
    (pkgs.writeShellScript "remove-fontconfig" ''
      if [ -e ${file} ] && ! [ -L ${file} ]; then
        echo "Removing existing ${file}"
        rm -fv ${file}
      else
        echo "remove-fontconfig not needed"
      fi
    '')
    .outPath;

  home-manager.users.${name} = {};

  viper.users = [name];

  services.xserver.displayManager = lib.mkIf ((builtins.length config.viper.users) == 1) {
    autoLogin.enable = true;
    autoLogin.user = name;
  };

  services.getty.autologinUser = name;

  systemd.services."getty@tty1".enable = false;
  systemd.services."getty@tty7".enable = false;

  fileSystems = {
    "dot-steam-${name}" = {
      mountPoint = "${home}/.steam";
      device = "${home}/.local/share/dot-steam";
      options = ["bind"];
    };
    "dot-var-${name}" = {
      mountPoint = "${home}/.var";
      device = "${home}/.local/share/dot-var";
      options = ["bind"];
    };
    "${home}/.mozilla" = {
      device = "${home}/.local/share/mozilla";
      options = ["bind"];
    };
  };
}
