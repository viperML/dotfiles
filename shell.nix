pkgs:
with pkgs.lib; let
  commands = with pkgs; {
    dot-update = ''
      ${fd}/bin/fd updater.sh --exec echo {}
      ${fd}/bin/fd updater.sh --exec {}
      nix flake update
    '';
    dot-check = ''
      ${fd}/bin/fd -e nix -x ${statix}/bin/statix check {}
      nix flake check
    '';
    dot-clean = ''
      git clean -xfe .envrc
    '';
  };
  pre-commit = pkgs.writeShellScript "pre-commit" ''
    ${pkgs.fd}/bin/fd update.sh -x chmod u+x {} \;
    treefmt --config-file misc/treefmt.toml --tree-root .
    nix flake check
    # This adds every change automatically
    # Can be considered an antipattern but I don't care,
    # as I always stage everything
    git add .
  '';
  pyEnv = pkgs.python3.withPackages (p:
    with p; [
      mypy
      toml
      types-toml
      black
      flake8
      requests
      #
    ]);
in
  pkgs.mkShell {
    name = "dotfiles-shell";
    packages = [
      pyEnv
      (attrValues (mapAttrs (name: value: pkgs.writeShellScriptBin name value) commands))

      # Formatting
      pkgs.treefmt
      pkgs.alejandra
      pkgs.black
      pkgs.stylua
      pkgs.shfmt
      pkgs.nix-prefetch
      pkgs.nix-update
      pkgs.nvfetcher
    ];
    shellHook = ''
      set -euo pipefail
      mkdir -p .git/hooks
      # ln -sf ${pre-commit} .git/hooks/pre-commit

      # Vscode is dumb
      if [[ ! -d .venv ]]; then
        ln -sf ${pyEnv} .venv
      fi
      echo ""

      echo "Available commands:"
      ${concatMapStringsSep "\n" (n: "echo '- ${n}'") (attrNames commands)}

      echo ""
    '';
    DRY = "1";
  }
