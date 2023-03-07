{
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
          (python311.withPackages (p: [
            p.mypy
            p.toml
            p.types-toml
            p.black
            p.flake8
            p.requests
            p.aiohttp
          ]))
          ruff

          config.packages.stylua
          shfmt
          treefmt

          babashka
        ];
        shellHook = ''
          venv="$(cd $(dirname $(which python)); cd ..; pwd)"
          ln -Tsf "$venv" .venv
        '';
        DRY = "1";
      };

    checks.devshell = config.devShells.default.inputDerivation;
  };
}
