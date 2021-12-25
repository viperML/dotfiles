# overlay

Each folder should hold a single package, with the upstream name. The derivation name
is adapted to nixpkgs naming standards.

Each derivation should be as close as posible to nixpkgs derivation standards,
such as avoid using `...` in imports, one import per line, etc.

These derivations should be able to be built without the flake support,
by using this command at the derivation folder:

```bash
nix-build --pure -E "with import <nixpkgs> {}; callPackage ./. {}"
```
