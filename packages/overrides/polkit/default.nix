{polkit}:
polkit.overrideAttrs (old: {
  patches =
    (old.patches or [])
    ++ [
      ./expiration.patch
    ];
})
