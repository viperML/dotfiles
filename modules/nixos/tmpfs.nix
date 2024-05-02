{lib, ...}: {
  fileSystems = let
    mkTmpfs = {
      device = "none";
      fsType = "tmpfs";
      options = ["size=2G" "mode=0755"];
      neededForBoot = true;
    };
  in {
    "/etc" = mkTmpfs;
    "/bin" = mkTmpfs;
    "/lib" = mkTmpfs;
    "/lib64" = mkTmpfs;
    "/opt" = mkTmpfs;
    "/srv" = mkTmpfs;
    "/usr" = mkTmpfs;
  };

  systemd.tmpfiles.rules = let
    move = {
      from,
      to,
    }: [
      "d ${to} 0755 root root - -"
      "z ${to} 0755 root root - -"
      "L ${from} - - - - ${to}"
    ];
  in
    lib.mkMerge [
      (move {
        from = "/etc/NetworkManager/system-connections";
        to = "/var/lib/NetworkManager-system-connections";
      })
    ];
}
