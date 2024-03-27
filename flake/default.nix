{ inputs
, lib
, ...
}: {
  imports = [
    ../packages
    ../misc/lib
    ../homes
    ../misc/bundlers.nix
    ../hosts
    ../modules
    # ../wrappers
  ];

  flake.templates = lib.pipe ../misc/templ [
    builtins.readDir
    (builtins.mapAttrs (name: _: {
      description = name;
      path = ../misc/templ/${name};
    }))
  ];

  systems = [
    "x86_64-linux"
    "aarch64-linux"
  ];

  perSystem =
    { pkgs
    , config
    , ...
    }: {
      devShells.flake = with pkgs;
        mkShell {
          packages = [
            rustc
            cargo
            rustfmt
            rust-analyzer-unwrapped
            clippy
          ];
          RUST_SRC_PATH = "${rustPlatform.rustLibSrc}";
        };

      packages.dotci = pkgs.callPackage ./dotci.nix {
        src = inputs.nix-filter.lib {
          root = ./.;
          include = [
            "src"
            "Cargo.toml"
            "Cargo.lock"
          ];
        };
      };

      checks = {
        inherit
          (config.packages)
          dotci
          ;
      };
    };
}
