{ pkgs, lib, ... }:
let
  targets = [ "graphical-session.target" ];
  sources = import ../../../npins;

  mkLink = f: {
    file.xdg_config."noctalia/${f}".source = builtins.toString ./${f};
  };
in
{
  config = lib.mkMerge [
    {
      packages = [
        pkgs.noctalia-shell
      ];

      systemd.services."noctalia" = {
        script = ''
          set -a
          eval "$(systemctl --user show-environment)"
          export PATH="${lib.makeBinPath [ pkgs.networkmanagerapplet ]}:$PATH"
          exec ${lib.getExe pkgs.noctalia-shell}
        '';

        partOf = targets;
        after = targets;
        wantedBy = targets;
      };

      file.xdg_config."noctalia/plugins/network-manager-vpn".source =
        "${sources.noctalia-plugins}/network-manager-vpn";
    }
    (mkLink "colors.json")
    (mkLink "plugins.json")
    (mkLink "settings.json")
  ];
}
