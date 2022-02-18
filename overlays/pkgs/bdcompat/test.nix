let
  pkgs = import (builtins.getFlake "nixpkgs") {};
  ImageEmojis = pkgs.fetchFromGitHub {
    owner = "MateusAquino";
    repo = "ImageEmojis";
    rev = "ac463507577de6c03e2ea2d512fb344d1d2ed9a8";
    sha256 = "1rv7ikivrpp7cxwfpx5zd1r197mymayglnv8y0jc0pg0k216jmai";
  };
in {
  bdCompat = pkgs.callPackage ./default.nix {
    plugins = [
      "${ImageEmojis}/ImageEmojis.plugin.js"
    ];
  };
}
