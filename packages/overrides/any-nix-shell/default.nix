{ any-nix-shell }:
any-nix-shell.overrideAttrs (_: {
  patches = [ ./no-color.patch ];
})
