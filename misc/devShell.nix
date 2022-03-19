{pkgs}:
pkgs.mkShell {
  name = "dotfiles-basic-shell";
  packages = with pkgs; [
    git
    jq
    nixos-install-tools
    ripgrep
    unzip
    gh

    (python3.withPackages (p:
      with p; [
        #keep
        grip
      ]))
  ];
  shellHook = ''
    ln -sf $PWD/bin/pre-commit.sh .git/hooks/pre-commit
    mkdir -p .venv/bin
    ln -sf `which python` .venv/bin/python
  '';
}
