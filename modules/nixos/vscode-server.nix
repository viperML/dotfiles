{
  config,
  pkgs,
  lib,
  ...
}: {
  programs.nix-ld.enable = true;
  home-manager.sharedModules = [
    {
      home.file.".vscode-server/server-env-setup" = {
        source = let
          NIX_LD_LIBRARY_PATH = lib.makeLibraryPath (with pkgs; [
            stdenv.cc.cc
            openssl
          ]);
        in
          pkgs.writeShellScript "server-env-setup" ''
            set -euo pipefail
            echo "== '~/.vscode-server/server-env-setup' SCRIPT START =="
            export NIX_LD_LIBRARY_PATH="${NIX_LD_LIBRARY_PATH}"
            export NIX_LD="$(cat ${pkgs.stdenv.cc}/nix-support/dynamic-linker)"
            echo "== '~/.vscode-server/server-env-setup' SCRIPT END =="
          '';
      };
    }
  ];
}
