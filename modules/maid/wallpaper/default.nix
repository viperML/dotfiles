{
  pkgs,
  ...
}:
{
  systemd.services."swaybg" = {
    wantedBy = [ "graphical-session.target" ];
    path = [
      pkgs.swaybg
    ];
    script = ''
      swaybg -c 000000
    '';
  };

  # systemd.services."waypaper-restore" = {
  #   wantedBy = [ "graphical-session.target" ];
  #   path = [
  #     pkgs.waypaper
  #     pkgs.swaybg
  #   ];
  #   serviceConfig.Type = "oneshot";
  #   after = [ "swaybg.service" ];
  #   script = ''
  #     waypaper --restore
  #   '';
  # };
  #
  # packages = [
  #   pkgs.waypaper
  # ];
}
