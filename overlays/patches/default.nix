final: prev: let
  inherit (prev) callPackage fetchFromGitHub;
in {
  any-nix-shell = callPackage ./any-nix-shell {inherit (prev) any-nix-shell;};
  obsidian = callPackage ./obsidian {inherit (prev) obsidian;};
  rose-pine-gtk-theme = callPackage ./rose-pine-gtk-theme {};

  python3 = prev.python3.override {
    packageOverrides = python3-final: python3-prev: {
      xlib = python3-prev.xlib.overrideAttrs (prevAttrs: {
        patches = [
          ./python-xlib-xauth-fix.patch
        ];
      });
    };
  };

  awesome = prev.awesome.overrideAttrs (_: {
    version = "unstable-2022-03-06";
    src = fetchFromGitHub {
      owner = "awesomeWM";
      repo = "awesome";
      rev = "392dbc21ab6bae98c5bab8db17b7fa7495b1e6a5";
      sha256 = "093zapjm1z33sr7rp895kplw91qb8lq74qwc0x1ljz28xfsbp496";
    };
  });

  stylua = prev.symlinkJoin {
    name = "stylua";
    paths = [prev.stylua];
    buildInputs = [prev.makeWrapper];
    postBuild = ''
      wrapProgram $out/bin/stylua \
        --add-flags "--config-path ${./stylua.toml}"
    '';
  };
}
