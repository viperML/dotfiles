{ pkgs, lib, ... }:
{
  packages = [
    pkgs.noctalia-shell
  ];

  file.xdg_config."noctalia".source = builtins.toString ./.;

  systemd.services."noctalia" = {
    script = ''
      set -a
      eval "$(systemctl --user show-environment)"
      ${lib.getExe pkgs.noctalia-shell}
    '';

    wantedBy = [ "graphical-session.target" ];
    after = [ "graphical-session.target" ];
  };
}
