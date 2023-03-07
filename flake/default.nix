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
    myPython = pkgs.python311.withPackages (p: [p.aiohttp]);
    writePython3 = with pkgs; writers.makePythonWriter myPython myPython.pkgs buildPackages.python3Packages;
    writePython3Bin = name: writePython3 "/bin/${name}";
  in {
    packages = {
      dotfiles-matrix = writePython3 "generate_matrix" {
        flakeIgnore = ["E501"];
      } (builtins.readFile ./matrix.py);
    };

    checks = {
      inherit
        (config.packages)
        dotfiles-matrix
        ;
    };
  };
}
