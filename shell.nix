{
  pkgs ? import ./. {},
  lib ? pkgs.lib,
}:
with lib; let
  pyEnv = pkgs.python3.withPackages (p:
    with p; [
      grip
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
in
  pkgs.mkShell {
    name = "dotfiles-basic-shell";
    packages = [
      pyEnv
      (attrValues (mapAttrs (name: value: pkgs.writeShellScriptBin name value) commands))
    ];
    shellHook = ''
      ln -sf $PWD/bin/pre-commit.sh .git/hooks/pre-commit
      mkdir -p .venv
      # Vscode is dumb
      ln -sf ${pyEnv}/bin .venv/
      echo ""
      echo "Available commands:"
      ${concatMapStringsSep "\n" (n: "echo '- ${n}'") (attrNames commands)}
      echo ""
    '';
    DRY = "1";
  }
