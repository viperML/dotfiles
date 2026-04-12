{ pkgs, lib, ... }:
let
  targets = [ "graphical-session.target" ];
in
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

    partOf = targets;
    after = targets;
    wantedBy = targets;
  };
}
