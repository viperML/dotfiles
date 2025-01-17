{
  guix,
  symlinkJoin,
  writeShellScriptBin,
  stdenv,
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
        export GUIX_LOCPATH="${guix-home}/lib/locale:$GUIX_LOCPATH"
      fi

      if [[ -f "${current-guix}/bin/${bin}" ]]; then
        exec -a "$0" "${current-guix}/bin/${bin}" "$@"
      else
        echo "Guix not found"
        exit 1
      fi
    '';
in
  symlinkJoin {
    inherit (guix) name pname version meta;
    paths = [
      (mkDispatch "guix")
      (mkDispatch "guix-daemon")
      (stdenv.mkDerivation {
        name = "guix-keys";
        inherit (guix) src;
        dontConfigure = true;
        dontBuild = true;
        installPhase = ''
          for key in etc/substitutes/*; do
            install -Dm644 $key $out/share/guix/$(basename $key)
          done
        '';
      })
    ];
  }
