final: prev: let
  inherit (prev) callPackage fetchFromGitHub;
  lib = prev.lib;
  versionGate = pkg: target:
    assert lib.assertMsg (lib.versionAtLeast target.version pkg.version)
    "${pkg.name} has reached the desired version upstream"; target;
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
    version = "unstable-2022-03-20";
    src = fetchFromGitHub {
      owner = "awesomeWM";
      repo = "awesome";
      rev = "86f67f4e089ee93ace999f3b523dd1c9cfaf6860";
      sha256 = "15x9kl5bssj5rrg18fij1k3m78h5yrg9pi9rkbj85kjm3l1flkcl";
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

  # starship = versionGate prev.starship (prev.starship.overrideAttrs (pA: rec {
  #   version = "1.4.2";
  #   pname = "starship";
  #   cargoSha256 = "0000000000000000000000000000000000000000000000000000";
  #   src = fetchFromGitHub {
  #     owner = "starship";
  #     repo = pname;
  #     rev = "v${version}";
  #     sha256 = "sha256-eCttQQ6pL8qkA1+O5p0ufsQo5vcypOEYxq+fNhyrdCo=";
  #   };
  # }));
}
