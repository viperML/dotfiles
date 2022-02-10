# overlay

Folders containing:
- [Overlay definition](https://nixos.wiki/wiki/Overlays) in `default.nix`
- One folder per package

- [pkgs](pkgs/default.nix): new packages, not available on nixpkgs
- [patches](patches/default.nix): modifications to existing packages

## Building

```bash
nix-build --pure --expr "let pkgs = import <nixpkgs> {}; in pkgs.callPackage ./default.nix {}"
# Or using the new nix command:
nix build --impure --expr 'let pkgs = import (builtins.getFlake "nixpkgs") {}; in pkgs.callPackage ./default.nix {}' -L
```
