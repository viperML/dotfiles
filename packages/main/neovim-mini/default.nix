{
  wrapNeovimUnstable,
  neovim-unwrapped,
  neovimUtils,
  vimPlugins,
  vimUtils,
  formats,
  writeTextDir,
  fetchFromGitHub,
  lib,
  symlinkJoin,
}: let
  neovim-with-packages = wrapNeovimUnstable neovim-unwrapped (neovimUtils.makeNeovimConfig {
    withNodeJs = false;
    withPython3 = false;
    customRC = ''
      :luafile ${./init.lua}
    '';

    configure.packages."placeholder".start = with vimPlugins; [
      nvim-comment
    ];
  });
in
  symlinkJoin {
    __nocachix = true;
    name = "neovim-mini-${lib.getVersion neovim-unwrapped}";
    paths = [neovim-with-packages];
    postBuild = ''
      rm -rf $out/share
      rm -rf $out/lib
      rm -rf $out/bin/nvim-*
      mv $out/bin/{nvim,nvim-mini}
    '';
  }
