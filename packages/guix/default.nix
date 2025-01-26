{
  guix,
  symlinkJoin,
  writeShellScriptBin,

  # passed by nixos module
  storeDir ? null,
  stateDir ? null,
}:
let
  dispatch =
    binName:
    writeShellScriptBin binName ''
      gusers=("/var/guix/profiles/per-user"/*)
      gprofiles="''${gusers[0]}"
      current_guix="$gprofiles/current-guix"

      if [[ -f "$current_guix/bin/${binName}" ]]; then
        exec -a "$0" "$current_guix/bin/${binName}" "$@"
      else
        echo "Falling back to Nix-installed Guix" >&2
        exec -a "$0" "${guix}/bin/${binName}" "$@"
      fi
    '';
in
symlinkJoin {
  inherit (guix)
    name
    pname
    version
    meta
    ;
  paths = [
    (dispatch "guix")
    (dispatch "guix-daemon")
    guix
  ];
}
