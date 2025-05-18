let
  sources = import ../npins;
  lib = import "${sources.nixpkgs}/lib";
in
import sources.nixpkgs {
  config = {
    allowInsecurePredicate =
      pkg:
      let
        pname = lib.getName pkg;
        byName = builtins.elem pname [
          "nix"
        ];
      in
      if byName then lib.warn "Allowing insecure package: ${pname}" true else false;

    allowUnfreePredicate = pkg: lib.warn "Allowing unfree package: ${lib.getName pkg}" true;
  };

  overlays = [
    (import ./overlay.nix lib)
  ];
}
