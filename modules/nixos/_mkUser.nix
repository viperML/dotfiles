name:
{
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (config.users.users.${name}) home;
in
{
  _file = ./_mkUser.nix;

  users.users.${name} = {
    inherit name;
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
    openssh.authorizedKeys.keys = [ ];
    hashedPasswordFile = "/var/lib/secrets/users.passwd";
    shell = "/run/current-system/sw/bin/fish";
  };

  systemd.tmpfiles.rules =
    [
      "d ${home} 0700 ${name} ${config.users.users.${name}.group} - -"
      "z ${home} 0700 ${name} ${config.users.users.${name}.group} - -"
    ]
    ++ (lib.flatten (
      map
        (d: [
          "d ${home}/${d} 0755 ${name} users - -"
          "z ${home}/${d} 0755 ${name} users - -"
        ])
        [
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
        ]
    ));
}
