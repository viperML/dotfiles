{...}: {
  perSystem = {
    pkgs,
    config,
    ...
  }: let
    mkApp = drv: {
      type = "app";
      program = pkgs.lib.getExe drv;
    };
  in {
    apps = {
      format = mkApp (pkgs.writeShellApplication {
        name = "dotfiles-format";
        runtimeInputs = with pkgs; [
          treefmt
          alejandra
          black
          config.packages.stylua
        ];
        text = ''
          treefmt --tree-root "$PWD" --config-file ${../misc/treefmt.toml}
        '';
      });

      cleanup = mkApp (
        pkgs.writeShellApplication {
          name = "dotfiles-cleanup";
          runtimeInputs = with pkgs; [
            fd
            deadnix
          ];
          text = ''
            fd '\.nix' --exclude 'generated\.nix' --exec deadnix -e -l
          '';
        }
      );
    };
  };
}
