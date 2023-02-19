{lib, ...}: {
  environment.extraInit =
    lib.concatMapStringsSep "\n" (file: ''
      if [[ -f ${file} ]]; then
        . ${file}
      fi
    '') [
      "/etc/profiles/per-user/$USER/etc/profile.d/hm-session-vars.sh"
      "/nix/var/nix/profiles/per-user/$USER/profile/etc/profile.d/hm-session-vars.sh"
    ];
}
