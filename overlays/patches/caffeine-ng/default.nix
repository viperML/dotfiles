{ caffeine-ng }:
caffeine-ng.overrideAttrs (prev: {
  patches = prev.patches ++ [
    ./sleep.patch
  ];
})
