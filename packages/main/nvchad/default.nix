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
  makeWrapper,
}: let
  nvchad-src = fetchFromGitHub {
    repo = "NvChad";
    owner = "NvChad";
    rev = "f9f03e7eaf095607f90ec4df96f786acc8427edc";
    sha256 = "sha256-RA+cGCRqleXZK4T55gsk0so1UEO+ImALNEcEPafe490=";
  };

  neovim-wrapped = wrapNeovimUnstable neovim-unwrapped (neovimUtils.makeNeovimConfig {
    extraLuaPackages = luaPackages:
      with luaPackages; [
        # keep
      ];
    # withNodeJs = true;
    # withPython3 = true;
    extraPython3Packages = pythonPackages:
      with pythonPackages; [
        # keep
      ];
    customRC = ''
      set rtp+=${nvchad-src}
      :luafile ${nvchad-src}/init.lua
    '';
  });
in
  symlinkJoin {
    name = "nvchad-${neovim-unwrapped.version}";
    paths = [neovim-wrapped];
    buildInputs = [makeWrapper];
    postBuild = ''
      mv $out/bin/nvim $out/bin/.nvim-wrapped
      makeWrapper $out/bin/.nvim-wrapped \
        $out/bin/nvchad \
        --set XDG_CONFIG_HOME \$HOME/.local/share/nvchad
      rm $out/bin/nvim*
    '';
  }
