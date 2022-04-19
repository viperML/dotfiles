{
  # Nixpkgs source to patch
  nixpkgs,
  PRS ? [
    # rec {
    #   PR = "168554";
    #   url = "https://github.com/NixOS/nixpkgs/pull/${PR}.patch";
    #   sha256 = "sha256-t+2LgUdbKbpxtT1wax2PCmzwGFQLrHJOs1QbskNVqV4=";
    #   exclude = ["*/all-tests.nix"];
    # }
  ],
  # pkgs to use for intermediate steps
  pkgs,
}:
with pkgs;
  applyPatches {
    name = ''nixpkgs-${lib.concatMapStringsSep "-" (y: y.PR) PRS}'';
    src = nixpkgs;
    patches = map (x: let
      patch = fetchpatch {
        name = x.PR;
        # url = "https://github.com/NixOS/nixpkgs/pull/${x.PR}.patch";
        inherit (x) sha256 url;
      };
      patched-patch = runCommandNoCC "${x.PR}-patched" {} ''
        ${patchutils}/bin/filterdiff ${lib.concatMapStringsSep " " (y: "-x '${y}'") (x.exclude or [])} ${patch} > $out
      '';
    in
      patched-patch)
    PRS;
  }
