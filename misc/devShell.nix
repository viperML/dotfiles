{pkgs}:
pkgs.mkShell {
  name = "dotfiles-basic-shell";
  packages = with pkgs; [
    git
    gnumake
    jq
    nixos-install-tools
    ripgrep
    unzip

    (python3.withPackages (p:
      with p; [
        #keep
      ]))
  ];
  shellHook = ''
    ln -sf $PWD/bin/pre-commit.sh .git/hooks/pre-commit
    mkdir -p .venv/bin
    ln -sf `which python` .venv/bin/python
  '';
}
