{
  name,
  uid,
}: {
  lib,
  config,
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

  home-manager.users.${name} = {};
  home-manager.sharedModules = [
    (args: {
      _file = ./_mkUser.nix;
      # Fix locale shenanigans
      home.activation.plasma-localerc = args.lib.hm.dag.entryAfter ["writeBoundary"] ''
        rm -vf $HOME/.config/plasma-localerc
      '';
    })
  ];

  systemd.tmpfiles.rules =
    [
      "d ${home} 0755 ${name} ${config.users.users.${name}.group} - -"
      "z ${home} 0755 ${name} ${config.users.users.${name}.group} - -"
    ]
    ++ (lib.flatten (map (d: [
        "d ${home}/${d} 0755 ${name} users - -"
        "z ${home}/${d} 0755 ${name} users - -"
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
      ]));
}
