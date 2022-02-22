{pkgs}:
pkgs.mkShell {
  name = "dotfiles-basic-shell";
  buildInputs = with pkgs; [
    git
    gnumake
    jq
    nixos-install-tools
    ripgrep
    unzip
  ];
  shellHook = ''
    ln -sf $PWD/bin/pre-commit.sh .git/hooks/pre-commit
  '';
}
