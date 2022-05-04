{
  nix-update,
  nix-prefetch,
  nix,
}:
(nix-update.override {
  inherit nix nix-prefetch;
})
.overrideAttrs (prev: {
  patches = [
    ./flake-support.patch
  ];
})
