{ pkgs, ... }:
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
}
