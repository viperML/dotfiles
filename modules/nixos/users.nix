{
  pkgs,
  lib,
  config,
  ...
}:
let
  defaultUserHome = "/var/home";
in
{
  users = {
    inherit defaultUserHome;

    users.ayats = {
      uid = 10000;
      maid = ../maid;
    };

    users.tmp = {
      uid = 10001;
      home = "/run/tmp-user";
    };
  };

  environment.shells = [
    pkgs.fish-viper
  ];

  imports = [
    (import ./_mkUser.nix "ayats")
    (import ./_mkUser.nix "tmp")
  ];

  systemd.tmpfiles.rules = [
    "z ${defaultUserHome} 0755 root root - -"
  ];

  systemd.services.tailscale-operator = lib.mkIf config.services.tailscale.enable rec {
    path = [
      config.services.tailscale.package
    ];
    wantedBy = [
      "tailscaled.service"
    ];
    after = wantedBy;
    script = ''
      set -x
      exec tailscale set --operator ayats
    '';
  };
}
