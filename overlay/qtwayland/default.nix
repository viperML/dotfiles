{ qtwayland }:

qtwayland.overrideAttrs (prev: {
  patches = prev.patches ++ [
    ./qtwayland-merge-24.patch
  ];
})
