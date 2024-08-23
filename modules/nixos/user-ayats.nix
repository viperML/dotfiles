{
  imports = [
    (import ./_mkUser.nix "ayats")
  ];

  users.users.ayats = {
    uid = 10000;
    home = "/var/home/ayats";
  };

  systemd.tmpfiles.rules = [
    "z /var/home 0755 root root - -"
  ];
}
