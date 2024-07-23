{
  guix,
  symlinkJoin,
  writeShellScriptBin,
  # passed by nixos module
  storeDir ? null,
  stateDir ? null,
}: let
  profiles = "/var/guix/profiles/per-user/ayats";
  current-guix = "${profiles}/current-guix";
  guix-home = "${profiles}/guix-home/profile";
  mkDispatch = bin:
    writeShellScriptBin bin ''
      if [[ -d "${guix-home}/lib/locale" ]]; then
        >&2 echo "Found locales in user's guix home"
        export GUIX_LOCPATH="${guix-home}/lib/locale:$GUIX_LOCPATH"
      else
        >&2 echo "Didn't find locales in user's guix home"
      fi

      if [[ -f "${current-guix}/bin/${bin}" ]]; then
        exec -a "$0" "${current-guix}/bin/${bin}" "$@"
      else
        exec -a "$0" ${guix}/bin/${bin} "$@"
      fi
    '';
in
  symlinkJoin {
    inherit (guix) name pname version meta;
    paths = [
      (mkDispatch "guix")
      (mkDispatch "guix-daemon")
      guix
    ];
  }
