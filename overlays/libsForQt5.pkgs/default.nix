final: prev: let
  inherit (prev) fetchFromGitHub;
in {
  libsForQt5 = prev.libsForQt5.overrideScope' (
    qtfinal: qtprev: let
      inherit (qtprev) callPackage;
    in rec {
      kwin-forceblur = callPackage ./kwin-forceblur {};
      lightly = callPackage ./lightly {};
      lightlyshaders = callPackage ./lightlyshaders {inherit (qtprev) kdelibs4support;};
      reversal-kde = callPackage ./reversal-kde {};
      sierrabreezeenhanced = callPackage ./sierrabreezeenhanced {};
    }
  );
}
