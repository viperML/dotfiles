{
  pkgs ? import ./. {},
  lib ? pkgs.lib,
}:
with lib; let
  pyEnv = pkgs.python3.withPackages (p:
    with p; [
      black
      flake8
      mypy
      types-toml
      #
    ]);
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
    dot-format = ''
      ${fd}/bin/fd -e nix -E deps --exec-batch ${alejandra}/bin/alejandra {}
    '';
    dot-clean = ''
      git clean -xfe .envrc
    '';
  };
  pre-commit = pkgs.writeShellScript "pre-commit" ''
    treefmt --config-file misc/treefmt.toml --tree-root .
    nix flake check
    # This adds every change automatically
    # Can be considered an antipattern but I don't care,
    # as I always stage everything
    git add .
  '';
in
  pkgs.mkShell {
    name = "dotfiles-basic-shell";
    packages = [
      pyEnv
      (attrValues (mapAttrs (name: value: pkgs.writeShellScriptBin name value) commands))

      # Formatting
      pkgs.treefmt
      pkgs.alejandra
      pkgs.black
      pkgs.stylua
      pkgs.shfmt
    ];
    shellHook = ''
      ln -sf ${pre-commit} .git/pre-commit

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
