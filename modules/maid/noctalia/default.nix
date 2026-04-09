{ pkgs, lib, ... }:
{
  packages = [
    pkgs.noctalia-shell
  ];

  file.xdg_config."noctalia".source = builtins.toString ./.;

  systemd.services."noctalia" = {
    serviceConfig = {
      ExecStart = lib.getExe pkgs.noctalia-shell;
    };

    wantedBy = [ "graphical-session.target" ];
    after = [ "graphical-session.target" ];
  };
}
