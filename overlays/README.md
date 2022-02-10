# overlay

Each folder should hold a single package, with the upstream name. The derivation name
is adapted to nixpkgs naming standards.

- `overlay-patches.nix` exports packages that are patches to existing ones in nixpkgs
- `overlay-pkgs.nix` exports packages, not in nixpkgs

## Building

```bash
nix-build --pure --expr "let pkgs = import <nixpkgs> {}; in pkgs.callPackage ./default.nix {}"
# Or using the new nix command:
nix build --impure --expr 'let pkgs = import (builtins.getFlake "nixpkgs") {}; in pkgs.callPackage ./default.nix {}' -L
```
