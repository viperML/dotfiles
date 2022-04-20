{any-nix-shell}:
any-nix-shell.overrideAttrs (_: {
  __nocachix = true;
  patches = [./no-color.patch];
})
