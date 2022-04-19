{
  # Nixpkgs source to patch
  nixpkgs,
  #
  PRS ? [],
  # pkgs to use for intermediate steps
  pkgs,
}:
with pkgs;
  applyPatches {
    name = "nixpkgs";
    src = nixpkgs;
    patches = map (x: let
      patch = fetchpatch {
        name = x.PR;
        url = "https://github.com/NixOS/nixpkgs/pull/${x.PR}.patch";
        inherit (x) sha256;
      };
      patched-patch = runCommandNoCC "${x.PR}-patched" {} ''
        ${patchutils}/bin/filterdiff ${lib.concatMapStringsSep " " (y: "-x '${y}'") x.exclude} ${patch} > $out
      '';
    in
      patched-patch)
    PRS;
  }
