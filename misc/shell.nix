_: {
  perSystem = {
    pkgs,
    config,
    ...
  }: {
    devShells.default =
      pkgs.mkShell.override {
        stdenv = pkgs.stdenvNoCC;
      } {
        name = "dotfiles-shell";
        packages = with pkgs; [
          (python3.withPackages (p: [
            p.mypy
            p.toml
            p.types-toml
            p.black
            p.flake8
            p.requests
          ]))

          alejandra
          config.packages.stylua
          shfmt
          treefmt
        ];
        shellHook = ''
          venv="$(cd $(dirname $(which python)); cd ..; pwd)"
          ln -Tsf "$venv" .venv
        '';
        DRY = "1";
      };

    packages.zzz_devshell = config.devShells.default;
  };
}
