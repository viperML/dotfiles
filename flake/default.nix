{
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
    mkBB = action:
      pkgs.writeShellApplication {
        name = "dotfiles-update";
        runtimeInputs = [
          pkgs.babashka
          config.packages.nvfetcher
        ];
        text = ''
          cd ${./.}
          bb -m ${action}
        '';
      };
  in {
    packages = {
      update = mkBB "update";
      generate = mkBB "generate";
    };
  };
}
