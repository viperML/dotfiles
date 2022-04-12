{pkgs}:
pkgs.mkShell {
  name = "dotfiles-basic-shell";
  packages = with pkgs; [
    (python3.withPackages (p:
      with p; [
        grip
        black
        flake8
      ]))
  ];
  shellHook = ''
    ln -sf $PWD/bin/pre-commit.sh .git/hooks/pre-commit
    mkdir -p .venv/bin
    ln -sf `which python` .venv/bin/python
  '';
  DRY = "1";
}
