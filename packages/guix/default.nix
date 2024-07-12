{
  guix,
  symlinkJoin,
  writeShellScriptBin,

  # passed by nixos module
  storeDir ? null,
  stateDir ? null,
}:

let
  profile = "/var/guix/profiles/per-user/ayats/current-guix";
  mkDispatch = bin:
    writeShellScriptBin bin ''
      if [[ -f "${profile}/bin/${bin}" ]]; then
        exec -a "$0" "${profile}/bin/${bin}" "$@"
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

