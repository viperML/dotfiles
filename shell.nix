pkgs:
with pkgs;
  mkShellNoCC {
    name = "dotfiles-shell";
    packages = [
      (python3.withPackages (p: [
        p.mypy
        p.toml
        p.types-toml
        p.black
        p.flake8
        p.requests
      ]))

      treefmt
      alejandra
      stylua
      shfmt
    ];
    shellHook = ''
      venv="$(cd $(dirname $(which python)); cd ..; pwd)"
      ln -Tsf "$venv" .venv
    '';
    DRY = "1";
  }
