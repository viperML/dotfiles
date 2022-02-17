let
  pkgs = import (builtins.getFlake "nixpkgs") {};
  imageEmojis = pkgs.fetchurl {
    url = "https://github.com/MateusAquino/ImageEmojis/releases/download/v0.2.3/ImageEmojis.plugin.js";
    sha256 = "1ialbrh94k2hak16zi0spcn1gff11f7j5qvgl5bnwq77xqiyp3fn";
  };
in {
  bdCompat = pkgs.callPackage ./default.nix {
    plugins = [
      imageEmojis
    ];
  };
}
