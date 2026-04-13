{ pkgs, lib, ... }:
let
  pkg = pkgs.callPackage ../../misc/auto-pp/package.nix { };
  targets = [ "multi-user.target" ];
in
{
  systemd.services.auto-pp = {
    wantedBy = targets;
    after = targets ++ [ "tuned-ppd.service" ];
    serviceConfig.ExecStart = lib.getExe pkg;
    serviceConfig.Restart = "on-failure";
  };
}
