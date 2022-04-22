{
  sublime4,
  runCommandNoCC,
  gnused,
  primaryBinary ? "sublime_text",
}: let
  sublime4-position = sublime4.meta.position;
  nix-patched = runCommandNoCC "common.nix" {nativeBuildInputs = [gnused];} ''
    sublime_source=$(echo "${sublime4.meta.position}" | cut -d":" -f1)
    cat $sublime_source
    echo $sublime_source
    sed "s/primaryBinary =.*/primaryBinary =\"${primaryBinary}\"/g" $sublime_source > $out
  '';
in
  import nix-patched
