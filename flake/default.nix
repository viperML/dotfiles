{lib, ...}: {
  imports = [
    ../packages
    ../misc/lib
    ../misc/bundlers.nix
    ../hosts
    ../modules/nixos
  ];

  flake.templates = lib.pipe ../misc/templ [
    builtins.readDir
    (builtins.mapAttrs (name: _: {
      description = name;
      path = ../misc/templ/${name};
    }))
  ];

  systems = ["x86_64-linux" "aarch64-linux"];

  perSystem = {
    pkgs,
    config,
    ...
  }: {
    devShells.default = with pkgs;
      mkShellNoCC {
        packages = [
          lua-language-server
          stylua
          taplo
        ];
      };
  };
}
