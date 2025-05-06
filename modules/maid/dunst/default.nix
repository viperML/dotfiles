{
  pkgs,
  lib,
  ...
}:
{
  systemd.services.dunst = {
    script = ''
      ${lib.getExe pkgs.dunst}
    '';
    wantedBy = ["graphical-session.target"];
  };
}
