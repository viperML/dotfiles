final: prev: let
  inherit (prev) callPackage fetchFromGitHub lib;

  versionGate = pkg: newAttrs: let
    newVersion = newAttrs.version;
    oldVersion = pkg.version;
    newPkg = pkg.overrideAttrs (_: newAttrs);
    result =
      if lib.versionOlder oldVersion newVersion
      then newPkg
      else throw "Package ${pkg.name} has reached the desired version";
  in
    result;
in {
  # Dont put stuff on my prompt
  any-nix-shell = prev.any-nix-shell.overrideAttrs (_: {
    patches = [./any-nix-shell.patch];
  });

  # Remove titlebars
  obsidian = prev.obsidian.overrideAttrs (_: {
    patchPhase = ''
      ${prev.nodePackages.asar}/bin/asar extract resources/obsidian.asar resources/obsidian
      rm resources/obsidian.asar
      ${prev.gnused}/bin/sed -i 's/frame: false/frame: true/' resources/obsidian/main.js
      ${prev.nodePackages.asar}/bin/asar pack resources/obsidian resources/obsidian.asar
      rm -rf resources/obsidian
    '';
  });

  # Changing src is not trivial, install steps change
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
    version = "unstable-2022-03-21";
    src = fetchFromGitHub {
      owner = "awesomeWM";
      repo = "awesome";
      rev = "c539e0e4350a42f813952fc28dd8490f42d934b3";
      sha256 = "111sgx9sx4wira7k0fqpdh76s9la3i8h40wgaii605ybv7n0nc0h";
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
