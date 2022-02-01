# overlay

Each folder should hold a single package, with the upstream name. The derivation name
is adapted to nixpkgs naming standards.

- `overlay-patches.nix` exports packages that are patches to existing ones in nixpkgs
- `overlay-pkgs.nix` exports packages, not in nixpkgs

## Building

```bash
nix-build --pure --expr "with import <nixpkgs> {}; callPackage ./default.nix {}"
# Or using the new nix command:
nix build --impure --expr 'with import (builtins.getFlake "nixpkgs") {}; pkgs.callPackage ./default.nix {}' -L
```
