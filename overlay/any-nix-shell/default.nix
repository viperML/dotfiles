{ any-nix-shell }:
any-nix-shell.overrideAttrs (
  prev: {
    patches = [
      ./no-color.patch
    ];
  }
)
