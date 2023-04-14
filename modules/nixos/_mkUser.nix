{
  name,
  uid,
}: {
  config,
  pkgs,
  lib,
  ...
}: let
  home = "/home/${name}";
in {
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
      "dialout"
    ];
    openssh.authorizedKeys.keys = [
    ];
    passwordFile = "/var/lib/secrets/users.passwd";
  };

  systemd.tmpfiles.rules =
    [
      "d ${home} 700 ${name} users - -"
      "z ${home} 700 ${name} users - -"
    ]
    ++ (lib.flatten (map (d: [
        "d ${home}/${d} 700 ${name} users - -"
        "z ${home}/${d} 700 ${name} users - -"
      ]) [
        ".config"
        ".local"
        ".local/share"
        ".cache"
        ".ssh"

        "Desktop"
        "Documents"
        "Downloads"
        "Music"
        "Pictures"
        "Videos"
      ]))
    ++ [
      "L+ ${home}/.config/plasma-localerc - - - - /dev/null"
    ];

  systemd.services."getty@tty1".enable = false;
  systemd.services."getty@tty7".enable = false;
}
