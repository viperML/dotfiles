{inputs, ...}: {
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

      generate_matrix = mkApp (
        with pkgs;
          writers.writePython3Bin "generate_matrix" {
            libraries = [python3.pkgs.requests];
          } (builtins.readFile ./generate_matrix.py)
      );
    };

    packages = {
      update = with pkgs;
        writeShellApplication {
          name = "dotfiles-update";
          runtimeInputs = [
            git
            config.packages.nvfetcher
          ];
          text =
            ''
              export NIX_PATH=nixpkgs=${inputs.nixpkgs}
            ''
            + lib.getExe (pkgs.writers.writePython3Bin "update" {} (builtins.readFile ./update.py));
        };
    };
  };
}
