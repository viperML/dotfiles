let
  pkgs = import ../.;
in
  with pkgs; mkShellNoCC {
    packages = [
      lua-language-server
      neovim.devMode
      stylua
    ];
  }
