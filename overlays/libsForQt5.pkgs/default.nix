final: prev: let
  inherit (prev) fetchFromGitHub;
in {
  libsForQt5 = prev.libsForQt5.overrideScope' (
    qtfinal: qtprev: let
      inherit (qtprev) callPackage;
    in rec {
      lightly = callPackage ./lightly {};
      sierrabreezeenhanced = callPackage ./sierrabreezeenhanced {};
      reversal-kde = callPackage ./reversal-kde {};
      kwin-forceblur = callPackage ./kwin-forceblur {};
      lightlyshaders = callPackage ./lightlyshaders {inherit (qtprev) kdelibs4support;};
    }
  );
}
