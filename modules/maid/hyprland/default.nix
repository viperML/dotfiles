{ pkgs, lib, ... }:
let
  targets = [ "graphical-session.target" ];

  mkService =
    cfg:
    lib.mkMerge [
      {
        wantedBy = targets;
        partOf = targets;
        after = targets;
      }
      cfg
    ];
in
{
  imports = [
    ../noctalia
  ];

  file.xdg_config."hypr".source = builtins.toString ./.;

  systemd.services = {
    cliphist = mkService {
      description = "Clipboard management daemon";
      serviceConfig = {
        ExecStart = "${lib.getExe' pkgs.wl-clipboard "wl-paste"} --watch ${lib.getExe pkgs.cliphist} store";
        Restart = "on-failure";
      };
    };

    cliphist-images = mkService {
      description = "Clipboard management daemon (images)";
      serviceConfig = {
        ExecStart = "${lib.getExe' pkgs.wl-clipboard "wl-paste"} --type image --watch ${lib.getExe pkgs.cliphist} store";
        Restart = "on-failure";
      };
    };
  };
}
