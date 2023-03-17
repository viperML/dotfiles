{inputs, ...}: {
  imports = [
    ../packages
    ../lib
    ../homes
    ../misc/shell.nix
    ../hosts
    ../modules
    ../bin
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
    ...
  }: let
    ciPython = pkgs.python311.withPackages (p: [p.aiohttp]);
    writePython3 = with pkgs; writers.makePythonWriter ciPython ciPython.pkgs buildPackages.python3Packages;
    writePython3Bin = name: writePython3 "/bin/${name}";
    ciPython' = pkgs.python3Minimal;
    writePython3' = with pkgs; writers.makePythonWriter ciPython' ciPython'.pkgs buildPackages.python3Packages;
    writePython3Bin' = name: writePython3' "/bin/${name}";
  in {
    packages = {
      dotfiles-matrix = writePython3Bin "dotfiles-matrix" {
        flakeIgnore = ["E501"];
      } (builtins.readFile ./matrix.py);

      dotfiles-generate = writePython3Bin "dotfiles-generate" {
        flakeIgnore = ["E501"];
      } (builtins.readFile ./generate.py);

      dotfiles-update-matrix = writePython3Bin' "dotfiles-update-matrix" {
        flakeIgnore = ["E501"];
      } (builtins.readFile ./update-matrix.py);

      dotfiles-update-nv = let
        original = writePython3Bin' "dotfiles-update-nv" {
          flakeIgnore = ["E501"];
        } (builtins.readFile ./update-nv.py);
      in
        pkgs.writeShellApplication {
          inherit (original) name;
          runtimeInputs = [
            pkgs.git
            config.packages.nvfetcher
          ];
          text = ''
            export NIX_PATH=nixpkgs=${inputs.nixpkgs}
            exec ${pkgs.lib.getExe original} "''${@}"
          '';
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
          fd '\.nix' --exclude 'generated\.nix' --exec deadnix -e -l
          treefmt --tree-root "$PWD" --config-file ${../misc/treefmt.toml}
        '';
      };
    };
  };
}
