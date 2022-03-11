final: prev: let
  inherit (prev) callPackage fetchFromGitHub;
in {
  any-nix-shell = callPackage ./any-nix-shell {inherit (prev) any-nix-shell;};
  obsidian = callPackage ./obsidian {inherit (prev) obsidian;};

  python3 = prev.python3.override {
    packageOverrides = python3-final: python3-prev: {
      xlib = python3-prev.xlib.overrideAttrs (prevAttrs: {
        patches = [
          ./python-xlib-xauth-fix.patch
        ];
      });
    };
  };
}
