{
  description = "flake-parts based template";

  inputs = {
    # nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.05";
    flake-parts = {
      # url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    flake-parts,
    ...
  }:
    flake-parts.lib.mkFlake {inherit self;} {
      systems = nixpkgs.lib.systems.flakeExposed;

      flake.overlays.default = final: prev: {
        PNAME = final.callPackage ./package.nix {};

        PNAME-dev =
          (final.PNAME.override {
            stdenv = final.clangStdenv;
          })
          .overrideAttrs (old: {
            nativeBuildInputs =
              old.nativeBuildInputs
              ++ (with final; [
                clang-tools
                lldb
              ]);
          });
      };

      perSystem = {
        pkgs,
        system,
        config,
        ...
      }: {
        _module.args.pkgs = import nixpkgs {
          inherit system;
          overlays = [self.overlays.default];
        };
        packages = {
          inherit
            (pkgs)
            PNAME
            PNAME-dev
            ;
          default = config.packages.PNAME;
        };
      };
    };
}
