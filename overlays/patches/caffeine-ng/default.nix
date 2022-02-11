{ caffeine-ng }:
caffeine-ng.overrideAttrs (
  prev: {
    patches =
      (prev.patches or [ ])
      ++ [
        ./sleep.patch
      ];
  }
)
