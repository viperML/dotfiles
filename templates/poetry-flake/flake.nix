{
  description = "My flake for reproducible environments with poetry";

  inputs = {
    nixpkgs.url = github:NixOS/nixpkgs/nixpkgs-unstable;
    flake-utils-plus.url = github:gytis-ivaskevicius/flake-utils-plus;
  };

  outputs = inputs@{ self, nixpkgs, flake-utils-plus, ... }:
  flake-utils-plus.lib.mkFlake {
    inherit self inputs;

    outputsBuilder = channels: {

      devShell = channels.nixpkgs.mkShell {
        name = "my-poetry-flake";

        buildInputs = with channels.nixpkgs; [
          # Change your python version here
          (python39.withPackages (pp: with pp; [
            poetry
          ]))
          # Add non-python packages here

          # ---
        ];

        shellHook = ''
          python -m venv .venv
          if [[ ! -f "pyproject.toml" ]]; then
            poetry init -n
          fi
          poetry env use .venv/bin/python
          poetry install --no-root
          source ./.venv/bin/activate
        '';

      };

    };
  };
}
