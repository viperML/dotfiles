{ multimc }:

multimc.overrideAttrs (prev: {

  patches = prev.patches ++ [
    ./sops.patch
  ];

})
