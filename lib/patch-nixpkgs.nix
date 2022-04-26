{
  # Nixpkgs source to patch
  nixpkgs,
  patches ? [
    # rec {
    #   name = "168554";
    #   url = "https://github.com/NixOS/nixpkgs/pull/${name}.patch";
    #   sha256 = "sha256-t+2LgUdbKbpxtT1wax2PCmzwGFQLrHJOs1QbskNVqV4=";
    #   exclude = ["*/all-tests.nix"];
    # }
  ],
  # pkgs to use for intermediate steps
  pkgs,
}:
with pkgs; let
  patches-with-exclusions = map (p: let
    patch = fetchpatch {
      inherit (p) name sha256 url;
    };
  in
    runCommandNoCC "${p.name}-patched" {} ''
      ${patchutils}/bin/filterdiff ${lib.concatMapStringsSep " " (y: "-x '${y}'") (p.exclude or [])} ${patch} > $out
    '')
  patches;
in
  applyPatches {
    name = ''nixpkgs-${lib.concatMapStringsSep "-" (p: p.name) patches}'';
    src = nixpkgs;
    patches = patches-with-exclusions;
  }
