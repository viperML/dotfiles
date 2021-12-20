{ pkgs ? import <nixpkgs> { } }:

pkgs.mkShell {
  buildInputs = with pkgs; [
    (python39.withPackages (pp: [ pp.poetry ]))
  ];

  shellHook = ''
    python -m venv .venv
    poetry env use .venv/bin/python
    poetry install --no-root
    source ./.venv/bin/activate
  '';
}
