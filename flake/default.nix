{...}: {
  imports = [
    ../packages
    ../misc/lib
    ../homes
    ../misc/shell.nix
    ../hosts
    ../modules
  ];

  flake = {
    templates = builtins.mapAttrs (name: _: {
      inherit (import ../misc/templ/${name}/flake.nix) description;
      path = ../misc/templ/${name};
    }) (builtins.readDir ../misc/templ);
  };

  systems = [
    "x86_64-linux"
    "aarch64-linux"
  ];

  perSystem = {
    pkgs,
    config,
    lib,
    ...
  }: let
    ciPython = let
      new = pkgs.python311;
      old = pkgs.python3Minimal;
    in
      if lib.versionAtLeast old.version new.version
      then old
      else new;
    ciPythonWithPkgs = ciPython.withPackages (p: with p; [aiohttp]);
    writePython3' = with pkgs; writers.makePythonWriter ciPythonWithPkgs ciPythonWithPkgs.pkgs buildPackages.python3Packages;
    writePython3Bin' = name: writePython3' "/bin/${name}";
  in {
    packages = let
      mkDotfilesPython = {
        name,
        file,
        runtimeInputs ? [],
      }: let
        unwrapped = writePython3Bin' name {
          flakeIgnore = ["E501"];
        } (builtins.readFile file);
      in
        pkgs.symlinkJoin {
          inherit (unwrapped) name meta;
          paths = [unwrapped];
          nativeBuildInputs = [pkgs.makeWrapper];
          postBuild = ''
            wrapProgram $out/bin/${unwrapped.meta.mainProgram or name} \
              --prefix PATH : ${lib.makeBinPath runtimeInputs}
          '';
        };
    in {
      dotfiles-generate-flake = mkDotfilesPython {
        name = "dotfiles-generate";
        file = ./generate-flake.py;
      };

      dotfiles-update-matrix = mkDotfilesPython {
        name = "dotfiles-update-matrix";
        file = ./update-matrix.py;
      };

      dotfiles-update-nv = mkDotfilesPython {
        name = "dotfiles-update-nv";
        file = ./update-nv.py;
        runtimeInputs = [
          pkgs.git
          config.packages.nvfetcher
        ];
      };

      dotfiles-build-matrix = mkDotfilesPython {
        name = "dotfiles-build-matrix";
        file = ./build-matrix.py;
      };

      dotfiles-tidy = pkgs.writeShellApplication {
        name = "dotfiles-tidy";
        runtimeInputs = [
          pkgs.treefmt
          pkgs.alejandra
          pkgs.black
          config.packages.stylua

          pkgs.fd
          pkgs.deadnix
        ];
        text = ''
          fd '\.nix' --exclude 'generated\.nix' --exclude 'flake\.nix' --exec deadnix -e -l
          treefmt --tree-root "$PWD" --config-file ${../misc/treefmt.toml}
        '';
      };

      inherit ciPythonWithPkgs;
    };

    checks = {
      inherit
        (config.packages)
        dotfiles-generate-flake
        dotfiles-update-matrix
        dotfiles-update-nv
        dotfiles-tidy
        dotfiles-build-matrix
        ;
    };
  };
}
